import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/models/invoice_model.dart';
import '../manager/invoice_details_cubit/technician_invoice_details_cubit.dart';

class TechnicianInvoiceDetailsView extends StatelessWidget {
  final int invoiceId;

  const TechnicianInvoiceDetailsView({
    super.key,
    required this.invoiceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TechnicianInvoiceDetailsCubit>()
        ..getInvoiceDetails(invoiceId),
      child: const _TechnicianInvoiceDetailsBody(),
    );
  }
}

class _TechnicianInvoiceDetailsBody extends StatelessWidget {
  const _TechnicianInvoiceDetailsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تفاصيل الفاتورة',
          style: AppStyle.headingMedium,
        ),
      ),
      body: BlocBuilder<TechnicianInvoiceDetailsCubit,
          TechnicianInvoiceDetailsState>(
        builder: (context, state) {
          if (state is TechnicianInvoiceDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is TechnicianInvoiceDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppStyle.bodyMedium,
                ),
              ),
            );
          }

          if (state is TechnicianInvoiceDetailsLoaded) {
            return _InvoiceDetailsContent(
              invoice: state.invoice,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InvoiceDetailsContent extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceDetailsContent({
    required this.invoice,
  });

  bool get _hasValidRejectionReason {
    final reason = invoice.rejectionReason?.trim();
    return (invoice.status == 4 || invoice.status == 3) &&
        reason != null &&
        reason.isNotEmpty &&
        reason != 'null' &&
        reason.toLowerCase() != 'string';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InvoiceHeader(invoice: invoice),
            const SizedBox(height: 14),
            _CustomerCard(invoice: invoice),
            const SizedBox(height: 14),
            if (invoice.items.isNotEmpty) ...[
              _ItemsCard(
                items: invoice.items,
              ),
              const SizedBox(height: 14),
            ],
            _SummaryCard(invoice: invoice),
            if (_hasValidRejectionReason) ...[
              const SizedBox(height: 14),
              _RejectionCard(
                reason: invoice.rejectionReason!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InvoiceHeader extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceHeader({
    required this.invoice,
  });

  Color _statusColor() {
    switch (invoice.status) {
      case 2:
        return AppColors.success;
      case 4:
      case 3:
        return AppColors.coral;
      default:
        return AppColors.warning;
    }
  }

  Color _statusBackground() {
    switch (invoice.status) {
      case 2:
        return AppColors.bgSuccess;
      case 4:
      case 3:
        return AppColors.bgError;
      default:
        return AppColors.bgWarning;
    }
  }

  String _statusText() {
    if (invoice.statusText != null && invoice.statusText!.isNotEmpty) {
      return invoice.statusText!;
    }

    switch (invoice.status) {
      case 2:
        return 'مؤكدة ومودعة بالخزنة';
      case 4:
      case 3:
        return 'مرفوضة من المحاسب';
      default:
        return 'في انتظار تأكيد المحاسب';
    }
  }

  @override
  Widget build(BuildContext context) {
    final invNum =
    invoice.invoiceNumber != null && invoice.invoiceNumber!.isNotEmpty
        ? invoice.invoiceNumber!
        : 'فاتورة #${invoice.invoiceId}';

    final ordNum =
    invoice.orderNumber != null && invoice.orderNumber!.isNotEmpty
        ? 'أوردر ${invoice.orderNumber}'
        : (invoice.orderId != null ? 'أوردر #${invoice.orderId}' : '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            invNum,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppStyle.headingMedium.copyWith(
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (ordNum.isNotEmpty)
                Expanded(
                  child: Text(
                    ordNum,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppStyle.hint,
                  ),
                ),

              if (ordNum.isNotEmpty) const SizedBox(width: 8),

              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBackground(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppStyle.labelMedium.copyWith(
                      color: _statusColor(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _CustomerCard extends StatelessWidget {
  final InvoiceModel invoice;

  const _CustomerCard({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'بيانات العميل',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline,
            label: 'الاسم',
            value: invoice.customerName != null && invoice.customerName!.isNotEmpty
                ? invoice.customerName!
                : 'غير متوفر',
          ),
          if (invoice.customerPhoneNumber != null &&
              invoice.customerPhoneNumber!.isNotEmpty)
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'رقم الهاتف',
              value: invoice.customerPhoneNumber!,
            ),
          if (invoice.areaName != null && invoice.areaName!.isNotEmpty)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'المنطقة',
              value: invoice.areaName!,
            ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List<InvoiceItemModel> items;

  const _ItemsCard({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'بنود الفاتورة',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'المنتج',
                  style: AppStyle.labelMedium,
                ),
              ),
              Expanded(
                child: Text(
                  'الكمية',
                  textAlign: TextAlign.center,
                  style: AppStyle.labelMedium,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'الإجمالي',
                  textAlign: TextAlign.left,
                  style: AppStyle.labelMedium,
                ),
              ),
            ],
          ),
          const Divider(
            height: 20,
            color: AppColors.borderSubtle,
          ),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.productName ?? 'منتج',
                      style: AppStyle.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.quantity.toString(),
                      textAlign: TextAlign.center,
                      style: AppStyle.bodySmall,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.totalPrice} ج.م',
                      textAlign: TextAlign.left,
                      style: AppStyle.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final InvoiceModel invoice;

  const _SummaryCard({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'ملخص الحساب',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          _AmountRow(
            label: 'قطع الغيار',
            amount: invoice.productsCost,
          ),
          const SizedBox(height: 10),
          _AmountRow(
            label: 'المصنعية',
            amount: invoice.laborCost,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: AppColors.borderSubtle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي المطلوب تحصيله',
                style: AppStyle.headingSmall,
              ),
              Text(
                '${invoice.totalAmount} ج.م',
                style: AppStyle.headingMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (invoice.paymentMethodName != null &&
              invoice.paymentMethodName!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'طريقة الدفع: ${invoice.paymentMethodName}',
                style: AppStyle.hint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RejectionCard extends StatelessWidget {
  final String reason;

  const _RejectionCard({
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgError,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.coral,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'سبب الرفض',
                  style: AppStyle.headingSmall.copyWith(
                    color: AppColors.coral,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppStyle.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppStyle.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            size: 18,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppStyle.hint,
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final num amount;

  const _AmountRow({
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${amount.toString()} ج.م',
          style: AppStyle.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppStyle.bodyMedium,
        ),
      ],
    );
  }
}
