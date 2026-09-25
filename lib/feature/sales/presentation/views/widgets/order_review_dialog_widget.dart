import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../technician/data/models/product_model.dart';

class OrderReviewDialogWidget extends StatelessWidget {
  final String customerName;
  final int orderType;
  final Map<int, int> selectedItems;
  final List<ProductModel> products;
  final String? notes;
  final num grandTotal;
  final bool isLoading;
  final VoidCallback onConfirm;

  const OrderReviewDialogWidget({
    super.key,
    required this.customerName,
    required this.orderType,
    required this.selectedItems,
    required this.products,
    this.notes,
    required this.grandTotal,
    required this.isLoading,
    required this.onConfirm,
  });

  String _getOrderTypeName(int type) {
    switch (type) {
      case 1:
        return 'تركيب';
      case 2:
        return 'صيانة دورية';
      case 3:
        return 'طوارئ';
      default:
        return 'صيانة ومتابعة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.bgCard,
        contentPadding: const EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.rate_review_outlined, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Text('مراجعة تفاصيل الأوردر', style: AppStyle.headingSmall),
                ],
              ),
              const Divider(height: 24, color: AppColors.borderSubtle),
              
              // Customer & Type Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildRow('اسم العميل:', customerName.isNotEmpty ? customerName : 'عميل مسجل'),
                    const SizedBox(height: 6),
                    _buildRow('نوع الأوردر:', _getOrderTypeName(orderType)),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Items Table
              const Text('قطع الغيار والمنتجات المحدد:', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: selectedItems.entries.map((entry) {
                    final product = products.firstWhere(
                      (p) => p.id == entry.key,
                      orElse: () => ProductModel(id: entry.key, name: 'قطعة غيار', retailPrice: 0, stockQuantity: 0),
                    );
                    final subtotal = product.retailPrice * entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${product.name} (x${entry.value})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.bodySmall,
                            ),
                          ),
                          Text('$subtotal ج.م', style: AppStyle.labelSmall.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              if (notes != null && notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('الملاحظات: $notes', style: AppStyle.hint.copyWith(fontSize: 12)),
              ],

              const Divider(height: 24, color: AppColors.borderSubtle),

              // Grand Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('إجمالي قيمة الأوردر:', style: AppStyle.headingSmall),
                  Text('$grandTotal ج.م', style: AppStyle.headingMedium.copyWith(color: AppColors.primary)),
                ],
              ),

              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : onConfirm,
                  icon: isLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                  label: Text(isLoading ? 'جاري الإرسال...' : 'تأكيد وإرسال الأوردر', style: AppStyle.buttonSmall),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('تعديل / إلغاء', style: AppStyle.labelMedium.copyWith(color: AppColors.coral)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: AppStyle.labelMedium.copyWith(color: AppColors.textHeading)),
        Text(label, style: AppStyle.hint),
      ],
    );
  }
}
