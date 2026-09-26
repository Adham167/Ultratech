import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/models/create_order_request_dto.dart';
import '../manager/create_order_cubit.dart';
import '../manager/create_order_state.dart';
import 'widgets/create_order_bottom_bar.dart';
import 'widgets/create_order_customer_banner.dart';
import 'widgets/create_order_notes_field.dart';
import 'widgets/create_order_type_selector.dart';

class CreateOrderView extends StatefulWidget {
  final int customerId;
  final String customerName;

  const CreateOrderView({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  late final CreateOrderCubit _cubit;
  final TextEditingController _notesController = TextEditingController();
  int _selectedType = 1; // 1: تركيب, 2: صيانة دورية, 3: طوارئ

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CreateOrderCubit>();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _sanitizeErrorMessage(String rawMessage) {
    final msg = rawMessage.trim();

    if (msg.isEmpty ||
        msg.contains('{') ||
        msg.contains('}') ||
        msg.contains('Exception') ||
        msg.contains('DioError') ||
        msg.contains('HTML') ||
        msg.contains('Http') ||
        msg.length > 80) {
      return 'تعذر إنشاء الأوردر. من فضلك حاول مرة أخرى.';
    }

    return msg;
  }

  void _submitOrder() {
    final request = CreateOrderRequestDto(
      customerId: widget.customerId,
      type: _selectedType,
      notes: _notesController.text.trim(),
    );

    _cubit.createOrder(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CreateOrderCubit, CreateOrderState>(
        listener: (context, state) {
          if (state is CreateOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إنشاء الأوردر بنجاح.',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: AppColors.success,
              ),
            );

            context.pop();
          } else if (state is CreateOrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _sanitizeErrorMessage(state.errMessage),
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: AppColors.coral,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CreateOrderLoading;

          return Scaffold(
            backgroundColor: AppColors.bgPage,
            appBar: AppBar(
              backgroundColor: AppColors.bgPage,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'إنشاء أوردر جديد',
                style: AppStyle.headingMedium,
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    CreateOrderCustomerBanner(
                      customerId: widget.customerId,
                      customerName: widget.customerName,
                    ),
                    const SizedBox(height: 14),
                    CreateOrderTypeSelector(
                      selectedType: _selectedType,
                      onTypeChanged: (type) {
                        setState(() => _selectedType = type);
                      },
                    ),
                    const SizedBox(height: 14),
                    CreateOrderNotesField(controller: _notesController),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CreateOrderBottomBar(
              isLoading: isLoading,
              onSubmit: _submitOrder,
            ),
          );
        },
      ),
    );
  }
}
