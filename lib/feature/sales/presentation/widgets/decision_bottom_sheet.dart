import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/usecases/submit_maintenance_decision_params.dart';

class DecisionBottomSheet extends StatefulWidget {
  final int maintenanceId;
  final Function(SubmitMaintenanceDecisionParams) onSubmit;

  const DecisionBottomSheet({
    super.key,
    required this.maintenanceId,
    required this.onSubmit,
  });

  @override
  State<DecisionBottomSheet> createState() => _DecisionBottomSheetState();
}

class _DecisionBottomSheetState extends State<DecisionBottomSheet> {
  int _selectedDecision = 2; // Default: Approved
  DateTime? _postponedDate;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
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
          const SizedBox(height: 20),
          const Text('اتخاذ قرار بشأن الصيانة', style: AppStyle.headingMedium),
          const SizedBox(height: 24),
          _buildDecisionOption(2, 'موافقة العميل (تحويل للفني)', Icons.check_circle_outline, AppColors.success),
          _buildDecisionOption(3, 'تأجيل الموعد', Icons.calendar_today_outlined, AppColors.warning),
          if (_selectedDecision == 3) ...[
            const SizedBox(height: 12),
            _buildDatePicker(),
          ],
          _buildDecisionOption(4, 'رفض الصيانة / إلغاء', Icons.cancel_outlined, AppColors.coral),
          const SizedBox(height: 16),
          const Text('ملاحظات إضافية', style: AppStyle.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            textAlign: TextAlign.right,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: _selectedDecision == 4 ? 'يرجى ذكر سبب الرفض...' : 'أدخل أي ملاحظات هنا...',
              hintStyle: AppStyle.hint,
              filled: true,
              fillColor: AppColors.bgPage,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('تأكيد القرار', style: AppStyle.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionOption(int value, String label, IconData icon, Color color) {
    final isSelected = _selectedDecision == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedDecision = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.bgPage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Row(
          children: [
            if (isSelected) Icon(Icons.check_circle, color: color, size: 20),
            const Spacer(),
            Text(label, style: AppStyle.labelMedium.copyWith(color: isSelected ? color : AppColors.textBody)),
            const SizedBox(width: 12),
            Icon(icon, color: isSelected ? color : AppColors.textMuted, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) setState(() => _postponedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.calendar_month, color: AppColors.warning),
            Text(
              _postponedDate == null ? 'اختر تاريخ التأجيل' : _postponedDate.toString().split(' ')[0],
              style: AppStyle.labelSmall.copyWith(color: _postponedDate == null ? AppColors.textHint : AppColors.textHeading),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_selectedDecision == 3 && _postponedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى اختيار تاريخ التأجيل')));
      return;
    }
    if (_selectedDecision == 4 && _notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى كتابة سبب الرفض في الملاحظات')));
      return;
    }

    widget.onSubmit(SubmitMaintenanceDecisionParams(
      maintenanceId: widget.maintenanceId,
      decision: _selectedDecision,
      postponedToDate: _postponedDate,
      notes: _notesController.text.trim(),
    ));
    Navigator.pop(context);
  }
}
