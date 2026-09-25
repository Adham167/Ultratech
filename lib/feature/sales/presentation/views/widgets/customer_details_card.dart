import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../domain/entities/area_entity.dart';
import '../../../domain/entities/customer_entity.dart';
import '../../../domain/entities/register_customer_params.dart';
import '../../manager/customer_registration_cubit.dart';
import '../../manager/customer_registration_state.dart';

class CustomerDetailsCard extends StatefulWidget {
  const CustomerDetailsCard({super.key});

  @override
  State<CustomerDetailsCard> createState() => _CustomerDetailsCardState();
}

class _CustomerDetailsCardState extends State<CustomerDetailsCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  int? _selectedAreaId;
  List<AreaEntity> _areas = [];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    setState(() {
      _selectedAreaId = null;
    });
    context.read<CustomerRegistrationCubit>().resetSearch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerRegistrationCubit, CustomerRegistrationState>(
      listener: (context, state) {
        if (state is PhoneSearchSuccess) {
          if (!state.result.isExisting) {
            _phoneController.text = state.searchedPhone;
          }
        }
        if (state is PhoneSearchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage), backgroundColor: AppColors.coral),
          );
        }
        if (state is AreasSuccess) {
          setState(() {
            _areas = state.areas;
          });
        }
        if (state is AreasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("خطأ في تحميل المناطق: ${state.errMessage}"),
              backgroundColor: AppColors.coral,
              action: SnackBarAction(
                label: 'إعادة المحاولة',
                textColor: Colors.white,
                onPressed: () => context.read<CustomerRegistrationCubit>().fetchAreas(),
              ),
            ),
          );
        }
        if (state is RegisterCustomerSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.success),
          );
          _resetForm();
        }
        if (state is RegisterCustomerFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage), backgroundColor: AppColors.coral),
          );
        }
      },
      builder: (context, state) {
        if (state is PhoneSearchLoading || state is RegisterCustomerLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is PhoneSearchSuccess && state.result.isExisting && state.result.customer != null) {
          return _buildCustomerSummaryCard(state.result.customer!);
        }

        return _buildRegistrationForm(state);
      },
    );
  }

  Widget _buildCustomerSummaryCard(CustomerEntity customer) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('ملخص بيانات العميل المسجل', style: AppStyle.headingSmall),
              const SizedBox(width: 8),
              const Icon(Icons.person_outline, color: AppColors.primary, size: 24),
            ],
          ),
          const Divider(height: 30, color: AppColors.bgPage),
          _buildSummaryItem('الاسم بالكامل', customer.fullName),
          _buildSummaryItem('رقم الهاتف', customer.phoneNumber),
          _buildSummaryItem('المنطقة', customer.areaName),
          _buildSummaryItem('العنوان', customer.address),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildBadge('الأجهزة: ${customer.devicesCount}', AppColors.purple),
              const SizedBox(width: 8),
              _buildBadge('الأوردرات: ${customer.ordersCount}', AppColors.sky),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push(
                      AppRouter.kCustomerProfileView,
                      extra: customer.id,
                    );
                  },
                  icon: const Icon(Icons.account_box_outlined, size: 18),
                  label:  Text('عرض البروفايل الكامل', style: AppStyle.buttonSmall.copyWith(color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      AppRouter.kCreateOrderView,
                      extra: {
                        'customerId': customer.id,
                        'customerName': customer.fullName,
                      },
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                  label: const Text('إنشاء أوردر جديد', style: AppStyle.buttonSmall),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _resetForm,
              child: const Text('فحص رقم جديد', style: AppStyle.labelMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value, style: AppStyle.labelMedium),
          const SizedBox(width: 8),
          Text('$label:', style: AppStyle.hint),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppStyle.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRegistrationForm(CustomerRegistrationState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('تسجيل بيانات عميل جديد', style: AppStyle.headingSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (v) => v == null || v.isEmpty ? 'برجاء أدخل رقم الهاتف' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'اسم العميل بالكامل',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => v == null || v.isEmpty ? 'برجاء أدخل اسم العميل' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _selectedAreaId,
              hint: const Text('اختر المنطقة'),
              items: _areas.map((a) {
                return DropdownMenuItem<int>(
                  value: a.id,
                  child: Text(a.name, style: AppStyle.labelSmall),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedAreaId = val),
              validator: (v) => v == null ? 'برجاء اختر المنطقة' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'العنوان التفصيلي',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (v) => v == null || v.isEmpty ? 'برجاء أدخل العنوان' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<CustomerRegistrationCubit>().registerCustomer(
                      RegisterCustomerParams(
                        fullName: _nameController.text.trim(),
                        phoneNumber: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                        areaId: _selectedAreaId!,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('تسجيل الحساب', style: AppStyle.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
