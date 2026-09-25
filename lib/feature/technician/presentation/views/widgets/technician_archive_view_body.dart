import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/invoice_model.dart';
import '../../manager/orders_cubit/technician_orders_cubit.dart';
import '../../manager/orders_cubit/technician_orders_state.dart';
import 'archive_invoice_card.dart';

class TechnicianArchiveViewBody extends StatefulWidget {
  const TechnicianArchiveViewBody({super.key});

  @override
  State<TechnicianArchiveViewBody> createState() =>
      _TechnicianArchiveViewBodyState();
}

class _TechnicianArchiveViewBodyState
    extends State<TechnicianArchiveViewBody> {
  int? _selectedStatusFilter;
  String _searchQuery = '';

  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<TechnicianOrdersCubit>().getMyInvoices(
          status: _selectedStatusFilter,
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterSelected(int? statusValue) {
    setState(() {
      _selectedStatusFilter = statusValue;
    });

    context.read<TechnicianOrdersCubit>().getMyInvoices(
          status: statusValue,
        );
  }

  void _openInvoiceDetails(int invoiceId) {
    if (invoiceId > 0) {
      context.push(
        '/technician-invoice-details/$invoiceId',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TechnicianOrdersCubit, TechnicianOrdersState>(
        builder: (context, state) {
          final cubit = context.read<TechnicianOrdersCubit>();
          final invoices = cubit.cachedInvoices;

          final query = _searchQuery.trim().toLowerCase();

          final filteredInvoices = invoices.where((invoice) {
            final matchesQuery = query.isEmpty ||
                (invoice.customerName?.toLowerCase().contains(query) ?? false) ||
                (invoice.orderNumber?.toLowerCase().contains(query) ?? false) ||
                (invoice.invoiceNumber?.toLowerCase().contains(query) ?? false) ||
                invoice.invoiceId.toString().contains(query);

            bool matchesFilter = true;
            if (_selectedStatusFilter != null) {
              if (_selectedStatusFilter == 1) {
                matchesFilter = (invoice.status == 1);
              } else if (_selectedStatusFilter == 2) {
                matchesFilter = (invoice.status == 2);
              } else if (_selectedStatusFilter == 4 || _selectedStatusFilter == 3) {
                matchesFilter = (invoice.status == 4 ||
                    invoice.status == 3 ||
                    (invoice.statusText != null &&
                        invoice.statusText!.trim().toLowerCase() == 'rejected'));
              }
            }

            return matchesQuery && matchesFilter;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getMyInvoices(
                status: _selectedStatusFilter,
                showLoading: false,
              );
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'أرشيف الفواتير',
                    style: AppStyle.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'سجل الفواتير المنتهية وحالة اعتماد المحاسب.',
                    style: AppStyle.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText:
                          'ابحث برقم الفاتورة أو الأوردر أو اسم العميل...',
                      hintStyle: AppStyle.hint,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      fillColor: AppColors.bgCard,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildFilterChip(
                          label: 'مرفوضة',
                          statusValue: 4,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'معتمدة',
                          statusValue: 2,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'معلقة',
                          statusValue: 1,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'الكل',
                          statusValue: null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state is TechnicianInvoicesLoading && invoices.isEmpty)
                    const SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (filteredInvoices.isEmpty)
                    SizedBox(
                      height: 220,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: AppColors.borderDisabled,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'لا توجد فواتير مطابقة في الأرشيف',
                              style: AppStyle.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredInvoices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final invoice = filteredInvoices[index];
                        final status = _getInvoiceStatus(invoice);

                        return ArchiveInvoiceCard(
                          customerName:
                              invoice.customerName ?? 'عميل بدون اسم',
                          orderId: (invoice.orderNumber != null && invoice.orderNumber!.isNotEmpty)
                              ? invoice.orderNumber!
                              : '#${invoice.orderId ?? invoice.invoiceId}',
                          date: invoice.createdAt ?? '',
                          price: '${invoice.totalAmount} ج.م',
                          area: invoice.areaName ?? '',
                          status: status,
                          rejectionReason: invoice.rejectionReason,
                          onTap: () {
                            _openInvoiceDetails(
                              invoice.invoiceId,
                            );
                          },
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

  int _getInvoiceStatus(InvoiceModel invoice) {
    return invoice.status ?? 1;
  }

  Widget _buildFilterChip({
    required String label,
    required int? statusValue,
  }) {
    final isSelected = _selectedStatusFilter == statusValue;

    return GestureDetector(
      onTap: () => _onFilterSelected(statusValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: AppStyle.labelMedium.copyWith(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
