import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class ArchiveInvoiceCard extends StatelessWidget {
  final String customerName;
  final String orderId;
  final String date;
  final String price;
  final String area;
  final int status;
  final String? rejectionReason;
  final VoidCallback? onTap;

  const ArchiveInvoiceCard({
    super.key,
    required this.customerName,
    required this.orderId,
    required this.date,
    required this.price,
    required this.area,
    this.status = 1,
    this.rejectionReason,
    this.onTap,
  });

  Color _getStatusBgColor() {
    switch (status) {
      case 2:
        return AppColors.bgSuccess;
      case 4:
      case 3:
        return AppColors.bgError;
      case 1:
      default:
        return AppColors.bgWarning;
    }
  }

  Color _getStatusBorderColor() {
    switch (status) {
      case 2:
        return AppColors.borderSuccess;
      case 4:
      case 3:
        return AppColors.coral.withValues(alpha: 0.3);
      case 1:
      default:
        return AppColors.borderWarning;
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 2:
        return AppColors.success;
      case 4:
      case 3:
        return AppColors.coral;
      case 1:
      default:
        return AppColors.warning;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 2:
        return Icons.check_circle_outline;
      case 4:
      case 3:
        return Icons.cancel_outlined;
      case 1:
      default:
        return Icons.access_time;
    }
  }

  String _getStatusText() {
    switch (status) {
      case 2:
        return 'مؤكدة ومودعة بالخزنة';
      case 4:
      case 3:
        return 'مرفوضة من المحاسب';
      case 1:
      default:
        return 'في انتظار تأكيد المحاسب';
    }
  }

  String _formatDate(String value) {
    if (value.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(value);

      return '${dateTime.year.toString().padLeft(4, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return value;
    }
  }

  bool get _hasValidRejectionReason {
    final reason = rejectionReason?.trim();
    return (status == 4 || status == 3) &&
        reason != null &&
        reason.isNotEmpty &&
        reason != 'null' &&
        reason.toLowerCase() != 'string';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.borderSubtle,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingSmall.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      customerName.isNotEmpty
                          ? customerName
                          : 'عميل بدون اسم',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: AppStyle.headingSmall.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      '$orderId • ${_formatDate(date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: AppStyle.hint.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusBgColor(),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusBorderColor(),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(),
                            size: 12,
                            color: _getStatusTextColor(),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _getStatusText(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.labelMedium.copyWith(
                                fontSize: 11,
                                color: _getStatusTextColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (area.trim().isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight
                              .withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.labelMedium.copyWith(
                            fontSize: 11,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              if (_hasValidRejectionReason) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.bgError,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.coral.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.coral,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'سبب الرفض: $rejectionReason',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppStyle.bodySmall.copyWith(
                            color: AppColors.coral,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
