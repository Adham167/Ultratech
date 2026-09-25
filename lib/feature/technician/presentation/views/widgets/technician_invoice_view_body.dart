import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/product_model.dart';
import '../../manager/orders_cubit/technician_orders_cubit.dart';
import '../../manager/orders_cubit/technician_orders_state.dart';
import 'product_item_card.dart';

class TechnicianInvoiceViewBody extends StatefulWidget {
  const TechnicianInvoiceViewBody({super.key});

  @override
  State<TechnicianInvoiceViewBody> createState() => _TechnicianInvoiceViewBodyState();
}

class _TechnicianInvoiceViewBodyState extends State<TechnicianInvoiceViewBody> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _laborCostController = TextEditingController(text: '250');
  final Map<int, int> _selectedProductQuantities = {};
  bool _isPaid = false;
  int _currentPage = 1;
  final int _pageSize = 5;
  String _selectedFilter = 'الكل';

  @override
  void initState() {
    super.initState();
    context.read<TechnicianOrdersCubit>().getProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _laborCostController.dispose();
    super.dispose();
  }

  num _getProductsCost(List<ProductModel> products) {
    num total = 0;
    _selectedProductQuantities.forEach((productId, qty) {
      if (qty > 0) {
        final p = products.firstWhere(
          (element) => element.id == productId,
          orElse: () => ProductModel(id: productId, name: '', retailPrice: 0, stockQuantity: 0),
        );
        total += (p.retailPrice * qty);
      }
    });
    return total;
  }

  num get _laborCost {
    final val = num.tryParse(_laborCostController.text.trim());
    return val ?? 0;
  }

  List<ProductModel> _getFilteredProducts(List<ProductModel> products) {
    final query = _searchController.text.trim().toLowerCase();
    return products.where((product) {
      final matchesSearch = query.isEmpty || product.name.toLowerCase().contains(query);
      bool matchesFilter = true;
      if (_selectedFilter == 'مخزون منخفض') {
        matchesFilter = product.isLowStock == true;
      } else if (_selectedFilter == 'متوفر') {
        matchesFilter = product.stockQuantity > 0;
      }
      return matchesSearch && matchesFilter;
    }).toList();
  }

  int _getTotalPages(int filteredCount) {
    if (filteredCount == 0) return 1;
    return (filteredCount / _pageSize).ceil();
  }

  List<ProductModel> _getCurrentPageProducts(List<ProductModel> filteredProducts) {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    if (startIndex >= filteredProducts.length) return [];
    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }

  void _goToPage(int page, int totalPages) {
    if (page < 1 || page > totalPages || page == _currentPage) return;
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<TechnicianOrdersCubit, TechnicianOrdersState>(
        listener: (context, state) {
          if (state is TechnicianProductsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: AppColors.coral,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<TechnicianOrdersCubit>();
          final allProducts = cubit.cachedProducts;
          final filteredProducts = _getFilteredProducts(allProducts);
          final totalPages = _getTotalPages(filteredProducts.length);
          final currentPageProducts = _getCurrentPageProducts(filteredProducts);

          final productsCost = _getProductsCost(allProducts);
          final laborCost = _laborCost;
          final totalAmount = productsCost + laborCost;

          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getProducts();
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'المنتجات والفاتورة',
                    style: AppStyle.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'اختر قطع الغيار والمنتجات المتاحة بالسيرفر.',
                    style: AppStyle.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  _buildSearchAndFilterBar(),
                  const SizedBox(height: 16),

                  if (state is TechnicianProductsLoading && allProducts.isEmpty)
                    const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is TechnicianProductsFailure && allProducts.isEmpty)
                    SizedBox(
                      height: 250,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppColors.coral),
                            const SizedBox(height: 12),
                            Text(state.errMessage, style: AppStyle.bodyMedium, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => cubit.getProducts(),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              child: const Text('إعادة المحاولة', style: AppStyle.buttonSmall),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (currentPageProducts.isEmpty)
                    const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('لا توجد منتجات مطابقة للبحث', style: AppStyle.bodySmall),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentPageProducts.length,
                      itemBuilder: (context, index) {
                        final product = currentPageProducts[index];
                        final count = _selectedProductQuantities[product.id] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ProductItemCard(
                            name: product.name,
                            price: product.retailPrice.toDouble(),
                            availableCount: product.stockQuantity,
                            isLowStock: product.isLowStock,
                            count: count,
                            onCountChanged: (newCount) {
                              setState(() {
                                _selectedProductQuantities[product.id] = newCount;
                              });
                            },
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),
                  if (filteredProducts.isNotEmpty) _buildPaginationBar(totalPages),
                  const SizedBox(height: 16),
                  InvoiceSummaryCard(
                    productsCost: productsCost,
                    laborCost: laborCost,
                    totalAmount: totalAmount,
                    laborCostController: _laborCostController,
                    onLaborCostChanged: (_) => setState(() {}),
                    isPaid: _isPaid,
                    onPaidChanged: (val) => setState(() => _isPaid = val),
                    onSubmit: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تسجيل الفاتورة بنجاح في القائمة', style: TextStyle(fontFamily: 'Cairo')),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: AppColors.bgPage,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              dropdownColor: AppColors.bgPage,
              icon: const Icon(Icons.filter_list, size: 20, color: AppColors.textMuted),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFilter = newValue;
                    _currentPage = 1;
                  });
                }
              },
              items: <String>['الكل', 'متوفر', 'مخزون منخفض']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppStyle.labelSmall),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.right,
            onChanged: (value) {
              setState(() {
                _currentPage = 1;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن قطعة غيار...',
              hintStyle: AppStyle.hint,
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _currentPage = 1);
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.bgCard,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationBar(int totalPages) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1, totalPages) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(totalPages, (index) {
                  final pageNum = index + 1;
                  final isSelected = pageNum == _currentPage;

                  return InkWell(
                    onTap: () => _goToPage(pageNum, totalPages),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: isSelected ? null : Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Center(
                        child: Text(
                          '$pageNum',
                          style: AppStyle.labelMedium.copyWith(
                            color: isSelected ? Colors.white : AppColors.textHeading,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _currentPage < totalPages ? () => _goToPage(_currentPage + 1, totalPages) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
