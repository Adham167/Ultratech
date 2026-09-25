import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/complete_order_request_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';

class CompleteOrderBottomSheet extends StatefulWidget {
  final OrderModel order;
  final List<ProductModel> availableProducts;
  final void Function(CompleteOrderRequestModel request) onSubmit;

  const CompleteOrderBottomSheet({
    super.key,
    required this.order,
    required this.availableProducts,
    required this.onSubmit,
  });

  @override
  State<CompleteOrderBottomSheet> createState() => _CompleteOrderBottomSheetState();
}

class _CompleteOrderBottomSheetState extends State<CompleteOrderBottomSheet> {
  final TextEditingController _laborCostController = TextEditingController(text: '150');
  final TextEditingController _notesController = TextEditingController();
  int _paymentMethod = 1; // 1: Cash, 2: Card
  final Map<int, int> _selectedProductQuantities = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Pre-populate quantities if order already has items
    if (widget.order.items.isNotEmpty) {
      for (final item in widget.order.items) {
        if (item.productId > 0 && item.quantity > 0) {
          _selectedProductQuantities[item.productId] = item.quantity;
        }
      }
    }
  }

  num get _productsCost {
    num total = 0;
    _selectedProductQuantities.forEach((productId, qty) {
      if (qty > 0) {
        final product = widget.availableProducts.firstWhere(
          (p) => p.id == productId,
          orElse: () => ProductModel(id: productId, name: '', retailPrice: 0, stockQuantity: 0),
        );
        total += (product.retailPrice * qty);
      }
    });
    return total;
  }

  num get _laborCost {
    final val = num.tryParse(_laborCostController.text.trim());
    return val ?? 0;
  }

  num get _totalAmount => _productsCost + _laborCost;

  void _submit() {
    setState(() {
      _errorMessage = null;
    });

    final List<CompleteOrderItemModel> items = [];
    _selectedProductQuantities.forEach((productId, qty) {
      if (productId > 0 && qty > 0) {
        items.add(CompleteOrderItemModel(productId: productId, quantity: qty));
      }
    });

    // Validation: Must select at least 1 item with quantity >= 1
    if (items.isEmpty) {
      setState(() {
        _errorMessage = 'يجب اختيار قطعة غيار واحدة على الأقل بكمية 1 أو أكثر لإصدار الفاتورة.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage!,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.coral,
        ),
      );
      return;
    }

    final request = CompleteOrderRequestModel(
      laborCost: _laborCost,
      paymentMethod: _paymentMethod,
      items: items,
      notes: _notesController.text.trim(),
    );

    widget.onSubmit(request);
  }

  @override
  void dispose() {
    _laborCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'إنهاء العمل وإصدار الفاتورة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '#${widget.order.orderNumber.isNotEmpty ? widget.order.orderNumber : widget.order.id}',
                    style: AppStyle.labelMedium.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('العميل: ', style: AppStyle.bodySmall),
                  Expanded(
                    child: Text(
                      widget.order.customerName.isNotEmpty
                          ? widget.order.customerName
                          : 'بدون اسم',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodySmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, color: AppColors.bgPage),
              
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.bgError,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.coral.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.coral, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppStyle.bodySmall.copyWith(color: AppColors.coral),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Text(
                'قطع الغيار / المستلزمات (مطلوبة):',
                style: AppStyle.headingSmall,
              ),
              const SizedBox(height: 8),
              if (widget.availableProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('لا توجد قطع غيار متاحة حالياً بالسيرفر', style: AppStyle.bodySmall),
                )
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.availableProducts.length,
                    itemBuilder: (context, index) {
                      final product = widget.availableProducts[index];
                      final qty = _selectedProductQuantities[product.id] ?? 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: qty > 0 ? AppColors.primary : AppColors.borderSubtle,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: AppStyle.labelMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        '${product.retailPrice} ج.م',
                                        style: AppStyle.bodySmall.copyWith(color: AppColors.primary),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'المتوفر: ${product.stockQuantity}',
                                        style: AppStyle.labelSmall.copyWith(
                                          fontSize: 10,
                                          color: product.isLowStock ? AppColors.coral : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.textMuted, size: 22),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: qty > 0
                                      ? () {
                                          setState(() {
                                            _selectedProductQuantities[product.id] = qty - 1;
                                            if (_selectedProductQuantities[product.id] == 0) {
                                              _selectedProductQuantities.remove(product.id);
                                            }
                                          });
                                        }
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '$qty',
                                    style: AppStyle.labelMedium.copyWith(fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 22),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      _selectedProductQuantities[product.id] = qty + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'تكلفة المصنعية / أجر اليد (ج.م):',
                style: AppStyle.headingSmall,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _laborCostController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'أدخل قيمة المصنعية',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'طريقة الدفع:',
                style: AppStyle.headingSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('نقداً (كاش)')),
                      selected: _paymentMethod == 1,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: _paymentMethod == 1 ? Colors.white : AppColors.textHeading,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _paymentMethod = 1);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('بطاقة / فيزا')),
                      selected: _paymentMethod == 2,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: _paymentMethod == 2 ? Colors.white : AppColors.textHeading,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _paymentMethod = 2);
                      },
                    ),
                  ),
                ],
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: AppColors.bgLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('تكلفة المنتجات / قطع الغيار:', style: AppStyle.bodySmall),
                        Text('$_productsCost ج.م', style: AppStyle.labelMedium),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('المصنعية:', style: AppStyle.bodySmall),
                        Text('$_laborCost ج.م', style: AppStyle.labelMedium),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي النهائي:', style: AppStyle.headingSmall),
                        Text(
                          '$_totalAmount ج.م',
                          style: AppStyle.headingMedium.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('إصدار الفاتورة وإنهاء العمل', style: AppStyle.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
