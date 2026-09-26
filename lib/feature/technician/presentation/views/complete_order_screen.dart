import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/models/complete_order_request_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';
import '../manager/orders_cubit/technician_orders_cubit.dart';
import '../manager/orders_cubit/technician_orders_state.dart';
import 'widgets/complete_order_customer_banner.dart';
import 'widgets/complete_order_product_item_row.dart';
import 'widgets/complete_order_search_header.dart';
import 'widgets/complete_order_summary_card.dart';
import 'widgets/number_pagination_bar.dart';

class CompleteOrderScreen extends StatefulWidget {
  final OrderModel order;

  const CompleteOrderScreen({
    super.key,
    required this.order,
  });

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
  late final TechnicianOrdersCubit _cubit;

  final TextEditingController _laborCostController =
  TextEditingController(text: '150');

  final TextEditingController _notesController = TextEditingController();

  int _paymentMethod = 1;

  final Map<int, int> _selectedProductQuantities = {};

  String _searchTerm = '';
  bool _onlyInStock = true;
  bool _showSelectedOnly = false;

  bool _isLoadingProducts = true;
  bool _isSubmitting = false;

  // إعدادات الـ Pagination المحلية الخاصة بالشاشة فقط
  int _currentPage = 1;
  static const int _pageSize = 8; // عدد المنتجات في كل صفحة

  @override
  void initState() {
    super.initState();

    _cubit = getIt<TechnicianOrdersCubit>();

    // تحميل قطع الغيار الموجودة بالفعل في الأوردر.
    for (final item in widget.order.items) {
      if (item.productId > 0 && item.quantity > 0) {
        _selectedProductQuantities[item.productId] = item.quantity;
      }
    }

    _loadProducts();
  }

  // =========================================================
  // Products
  // =========================================================

  Future<void> _loadProducts() async {
    if (mounted) {
      setState(() {
        _isLoadingProducts = true;
      });
    }

    try {
      await _cubit.getProducts();

      if (!mounted) {
        return;
      }

      if (_cubit.cachedProducts.isNotEmpty) {
        final availableProductIds = _cubit.cachedProducts
            .where(
              (product) => product.stockQuantity > 0,
        )
            .map((product) => product.id)
            .toSet();

        setState(() {
          _selectedProductQuantities.removeWhere(
                (productId, quantity) => !availableProductIds.contains(productId),
          );
        });
      }
    } catch (e) {
      debugPrint(
        'CompleteOrderScreen - getProducts error: $e',
      );

      if (mounted) {
        _showErrorMessage(
          'تعذر تحميل قطع الغيار. حاول مرة أخرى.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  // =========================================================
  // Calculations
  // =========================================================

  num get _productsCost {
    num total = 0;

    for (final entry in _selectedProductQuantities.entries) {
      final productId = entry.key;
      final quantity = entry.value;

      if (quantity <= 0) {
        continue;
      }

      ProductModel? product;

      for (final item in _cubit.cachedProducts) {
        if (item.id == productId) {
          product = item;
          break;
        }
      }

      if (product != null) {
        total += product.retailPrice * quantity;
      }
    }

    return total;
  }

  num get _laborCost {
    final value = _laborCostController.text.trim();

    if (value.isEmpty) {
      return 0;
    }

    return num.tryParse(value) ?? 0;
  }

  num get _totalAmount {
    return _productsCost + _laborCost;
  }

  // =========================================================
  // Filtering & Local Pagination
  // =========================================================

  List<ProductModel> _getFilteredProducts(
      List<ProductModel> products,
      ) {
    final search = _searchTerm.trim().toLowerCase();

    return products.where((product) {
      final matchesStock = !_onlyInStock || product.stockQuantity > 0;

      if (!matchesStock) {
        return false;
      }

      final productName = product.name.toLowerCase();

      final matchesSearch = search.isEmpty ||
          productName.contains(search) ||
          product.id.toString().contains(search);

      final matchesSelected = !_showSelectedOnly ||
          (_selectedProductQuantities[product.id] ?? 0) > 0;

      return matchesSearch && matchesSelected;
    }).toList();
  }

  // اقتطاع المنتجات الخاصة بالصفحة الحالية فقط
  List<ProductModel> _getPagedProducts(List<ProductModel> filteredProducts) {
    final startIndex = (_currentPage - 1) * _pageSize;
    if (startIndex >= filteredProducts.length) {
      return [];
    }
    final endIndex = startIndex + _pageSize;
    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }

  int _calculateTotalPages(int totalItems) {
    if (totalItems == 0) return 1;
    return (totalItems / _pageSize).ceil();
  }

  // =========================================================
  // Build Request
  // =========================================================

  List<CompleteOrderItemModel> _buildOrderItems() {
    final items = <CompleteOrderItemModel>[];

    for (final entry in _selectedProductQuantities.entries) {
      final productId = entry.key;
      final quantity = entry.value;

      if (productId > 0 && quantity > 0) {
        items.add(
          CompleteOrderItemModel(
            productId: productId,
            quantity: quantity,
          ),
        );
      }
    }

    return items;
  }

  // =========================================================
  // Submit Invoice
  // =========================================================

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    final items = _buildOrderItems();
    final laborText = _laborCostController.text.trim();

    if (laborText.isNotEmpty && num.tryParse(laborText) == null) {
      _showErrorMessage('من فضلك أدخل قيمة صحيحة للمصنعية.');
      return;
    }

    if (_laborCost < 0) {
      _showErrorMessage('قيمة المصنعية لا يمكن أن تكون سالبة.');
      return;
    }

    final confirmed = await _showPaymentConfirmation();

    if (!confirmed || !mounted) {
      return;
    }

    final request = CompleteOrderRequestModel(
      laborCost: _laborCost,
      paymentMethod: _paymentMethod,
      items: items,
      notes: _notesController.text.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _cubit.completeOrder(
        widget.order.id,
        request,
      );
    } catch (e, stackTrace) {
      debugPrint('CompleteOrderScreen - completeOrder exception: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showErrorMessage('حدث خطأ غير متوقع أثناء إنهاء الطلب.');
    }
  }

  // =========================================================
  // Payment Confirmation
  // =========================================================

  Future<bool> _showPaymentConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.bgCard,
            title: const Row(
              children: [
                Icon(
                  Icons.payments_rounded,
                  color: AppColors.success,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تأكيد استلام المبلغ',
                    style: AppStyle.headingSmall,
                  ),
                ),
              ],
            ),
            content: Text(
              'هل تم استلام مبلغ ${_totalAmount.toStringAsFixed(2)} ج.م من العميل؟',
              style: AppStyle.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: Text(
                  'إلغاء',
                  style: AppStyle.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text(
                  'نعم، تم الاستلام',
                  style: AppStyle.buttonSmall,
                ),
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: AppColors.coral,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _laborCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: AppBar(
          backgroundColor: AppColors.bgPage,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'إصدار الفاتورة وإنهاء العمل',
            style: AppStyle.headingMedium,
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<TechnicianOrdersCubit, TechnicianOrdersState>(
            listener: (context, state) {
              if (state is TechnicianActionSuccess &&
                  state.actionType == 'complete' &&
                  state.orderId == widget.order.id) {
                if (!mounted) return;

                setState(() {
                  _isSubmitting = false;
                });

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم إصدار الفاتورة وإنهاء العمل بنجاح.',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );

                Future.delayed(
                  const Duration(milliseconds: 500),
                      () {
                    if (!mounted) return;
                    context.go(AppRouter.kTechnicianOrdersView);
                  },
                );
              } else if (state is TechnicianActionFailure &&
                  state.actionType == 'complete') {
                if (!mounted) return;

                setState(() {
                  _isSubmitting = false;
                });

                final serverMessage = state.errMessage.trim().isNotEmpty
                    ? state.errMessage
                    : 'تعذر إنهاء الطلب. تأكد من البيانات وحاول مرة أخرى.';

                _showErrorMessage(serverMessage);
              }
            },
            builder: (context, state) {
              final products = _cubit.cachedProducts;
              final filteredProducts = _getFilteredProducts(products);
              final pagedProducts = _getPagedProducts(filteredProducts);
              final totalPages = _calculateTotalPages(filteredProducts.length);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompleteOrderCustomerBanner(order: widget.order),
                    const SizedBox(height: 16),
                    const Text(
                      'قطع الغيار / المستلزمات:',
                      style: AppStyle.headingSmall,
                    ),
                    const SizedBox(height: 8),
                    CompleteOrderSearchHeader(
                      searchTerm: _searchTerm,
                      onSearchChanged: (value) {
                        setState(() {
                          _searchTerm = value.trim();
                          _currentPage = 1; // إعادة الضبط للصفحة الأولى
                        });
                      },
                      onlyInStock: _onlyInStock,
                      onInStockToggled: (value) {
                        setState(() {
                          _onlyInStock = value;
                          _currentPage = 1;
                        });
                      },
                      showSelectedOnly: _showSelectedOnly,
                      onSelectedOnlyToggled: (value) {
                        setState(() {
                          _showSelectedOnly = value;
                          _currentPage = 1;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingProducts)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else if (products.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'لا توجد قطع غيار متاحة حاليًا.',
                            style: AppStyle.bodySmall,
                          ),
                        ),
                      )
                    else if (filteredProducts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'لا توجد قطع غيار مطابقة للبحث أو الفلتر.',
                              style: AppStyle.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pagedProducts.length,
                              itemBuilder: (context, index) {
                                final product = pagedProducts[index];
                                final quantity =
                                    _selectedProductQuantities[product.id] ?? 0;

                                return CompleteOrderProductItemRow(
                                  product: product,
                                  quantity: quantity,
                                  onQuantityChanged: (newQuantity) {
                                    setState(() {
                                      if (newQuantity <= 0) {
                                        _selectedProductQuantities
                                            .remove(product.id);
                                      } else {
                                        final maxQuantity = product.stockQuantity;
                                        _selectedProductQuantities[product.id] =
                                        newQuantity > maxQuantity
                                            ? maxQuantity
                                            : newQuantity;
                                      }
                                    });
                                  },
                                );
                              },
                            ),

                            // شريط التنقل بين الصفحات بشكل محلي
                            NumberPaginationBar(
                              currentPage: _currentPage,
                              totalPages: totalPages,
                              onPageChanged: (newPage) {
                                setState(() {
                                  _currentPage = newPage;
                                });
                              },
                            ),
                          ],
                        ),
                    const SizedBox(height: 16),
                    const Text(
                      'تكلفة المصنعية / أجر اليد (ج.م):',
                      style: AppStyle.headingSmall,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _laborCostController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'أدخل قيمة المصنعية',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: AppColors.bgCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.borderSubtle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ملاحظات العمل / تقرير الصيانة:',
                      style: AppStyle.headingSmall,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'أدخل أي ملاحظات إضافية تم تنفيذها...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: AppColors.bgCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.borderSubtle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CompleteOrderSummaryCard(
                      productsCost: _productsCost,
                      laborCost: _laborCost,
                      totalAmount: _totalAmount,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.bgCard,
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'إصدار الفاتورة وإنهاء العمل',
                  style: AppStyle.button,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}