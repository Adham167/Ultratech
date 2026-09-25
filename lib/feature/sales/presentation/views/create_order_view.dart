import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../technician/data/models/product_model.dart';
import '../../data/models/create_order_request_dto.dart';
import '../manager/create_order_cubit.dart';
import '../manager/create_order_state.dart';
import 'widgets/create_order_bottom_bar.dart';
import 'widgets/create_order_customer_banner.dart';
import 'widgets/create_order_notes_field.dart';
import 'widgets/create_order_product_picker.dart';
import 'widgets/create_order_type_selector.dart';
import 'widgets/order_review_dialog_widget.dart';
import 'widgets/order_success_dialog_widget.dart';

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
  Map<int, int> _selectedItems = {}; // productId -> quantity

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CreateOrderCubit>();
    _cubit.fetchProducts();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  num get _calculatedTotalAmount {
    num total = 0;
    _selectedItems.forEach((productId, qty) {
      final product = _cubit.cachedProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => ProductModel(id: productId, name: '', retailPrice: 0, stockQuantity: 0),
      );
      total += product.retailPrice * qty;
    });
    return total;
  }

  String _extractOrderNumber(String rawMessage) {
    if (rawMessage.isEmpty) return 'قيد التجهيز';
    final match = RegExp(r'#?\d+').firstMatch(rawMessage);
    if (match != null) {
      final val = match.group(0)!;
      return val.startsWith('#') ? val : '#$val';
    }
    if (!rawMessage.contains('{') && !rawMessage.contains('Exception') && rawMessage.length <= 25) {
      return rawMessage;
    }
    return 'جديد';
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
      return 'حدث خطأ أثناء إنشاء الأوردر، يرجى المحاولة لاحقاً';
    }
    return msg;
  }

  void _onReviewAndSubmit() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('برجاء تحديد قطعة غيار أو منتج واحد على الأقل', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.coral,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<CreateOrderCubit, CreateOrderState>(
            listener: (context, state) {
              if (state is CreateOrderSuccess) {
                Navigator.pop(dialogContext); // Close review dialog
                _showSuccessDialog(state.message);
              } else if (state is CreateOrderFailure) {
                Navigator.pop(dialogContext); // Close review dialog
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
              return OrderReviewDialogWidget(
                customerName: widget.customerName,
                orderType: _selectedType,
                selectedItems: _selectedItems,
                products: _cubit.cachedProducts,
                notes: _notesController.text.trim(),
                grandTotal: _calculatedTotalAmount,
                isLoading: isLoading,
                onConfirm: () {
                  final items = _selectedItems.entries
                      .map((e) => CreateOrderItemDto(productId: e.key, quantity: e.value))
                      .toList();

                  final request = CreateOrderRequestDto(
                    customerId: widget.customerId,
                    type: _selectedType,
                    notes: _notesController.text.trim(),
                    items: items,
                  );

                  _cubit.createOrder(request);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    final orderNum = _extractOrderNumber(message);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return OrderSuccessDialogWidget(
          orderNumber: orderNum,
          customerName: widget.customerName,
          totalAmount: _calculatedTotalAmount,
          onViewDetails: () {
            context.pop();
          },
          onClose: () {
            context.pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<CreateOrderCubit, CreateOrderState>(
        builder: (context, state) {
          final isLoading = state is CreateOrderLoading;

          return Scaffold(
            backgroundColor: AppColors.bgPage,
            appBar: AppBar(
              backgroundColor: AppColors.bgPage,
              elevation: 0,
              centerTitle: true,
              title: const Text('إنشاء أوردر جديد', style: AppStyle.headingMedium),
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
                      onTypeChanged: (type) => setState(() => _selectedType = type),
                    ),
                    const SizedBox(height: 14),
                    CreateOrderProductPicker(
                      products: _cubit.cachedProducts,
                      selectedItems: _selectedItems,
                      onChanged: (map) => setState(() => _selectedItems = map),
                    ),
                    const SizedBox(height: 14),
                    CreateOrderNotesField(controller: _notesController),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CreateOrderBottomBar(
              totalAmount: _calculatedTotalAmount,
              isLoading: isLoading,
              onSubmit: _onReviewAndSubmit,
            ),
          );
        },
      ),
    );
  }
}
