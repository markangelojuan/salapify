import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/domain/entities/income_source.dart';
import 'package:salapify/features/transaction/presentation/controllers/income_source_controller.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class IncomeFormScreen extends ConsumerStatefulWidget {
  const IncomeFormScreen({super.key, this.existingSource});

  final IncomeSource? existingSource;

  bool get isEditing => existingSource != null;

  @override
  ConsumerState<IncomeFormScreen> createState() => _IncomeFormScreenState();
}

class _IncomeFormScreenState extends ConsumerState<IncomeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sourceController;
  late final TextEditingController _amountController;

  late bool _isRecurring;
  int? _recurringDay;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingSource;
    _sourceController = TextEditingController(text: existing?.source ?? '');
    _amountController = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(2) : '',
    );
    _isRecurring = existing?.isRecurring ?? false;
    _recurringDay = existing?.recurringDay ?? DateTime.now().day;
    _date = existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickRecurringDay() async {
    final now = DateTime.now();
    final daysInCurrentMonth = DateTime(now.year, now.month + 1, 0).day;
    final initialDay = (_recurringDay ?? now.day).clamp(1, daysInCurrentMonth);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, initialDay),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _recurringDay = picked.day);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _currentPeriodLabel(BudgetingPeriod period, int firstHalfEndDay) {
    final now = DateTime.now();
    final monthLabel = '${_monthNames[now.month - 1]} ${now.year}';
    if (period == BudgetingPeriod.monthly) return monthLabel;
    final half = now.day <= firstHalfEndDay ? '1st half' : '2nd half';
    return '$half of $monthLabel';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());
    final actions = ref.read(incomeSourceActionsProvider.notifier);

    if (widget.isEditing) {
      final updated = widget.existingSource!.copyWith(
        source: _sourceController.text.trim(),
        amount: amount,
        isRecurring: _isRecurring,
        recurringDay: _isRecurring ? _recurringDay : null,
        clearRecurringDay: !_isRecurring,
        date: _date,
      );
      await actions.updateSource(updated);
    } else {
      final newSource = IncomeSource(
        id: const Uuid().v4(),
        source: _sourceController.text.trim(),
        amount: amount,
        isRecurring: _isRecurring,
        recurringDay: _isRecurring ? _recurringDay : null,
        date: _isRecurring ? DateTime.now() : _date,
        createdAt: DateTime.now(),
      );
      await actions.addSource(newSource);
    }

    if (!mounted) return;

    final state = ref.read(incomeSourceActionsProvider);
    if (state.hasError) {
      CommonSnackbar.showError(context, state.error!);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.watch(firstHalfEndDaySettingProvider).value ?? 15;
    final actionsState = ref.watch(incomeSourceActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Income' : 'Add Income'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextField(
                  controller: _sourceController,
                  icon: Icons.badge_outlined,
                  hint: 'e.g. Salary, Freelance, Gift',
                  label: 'Source',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Source is required';
                    }
                    if (value.trim().length > 50) {
                      return 'Keep it under 50 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                CommonTextField(
                  controller: _amountController,
                  icon: Icons.attach_money_rounded,
                  hint: '0.00',
                  label: 'Amount',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Text('Type', style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('One-time')),
                    ButtonSegment(value: true, label: Text('Recurring')),
                  ],
                  selected: {_isRecurring},
                  onSelectionChanged: (selection) =>
                      setState(() => _isRecurring = selection.first),
                ),
                const SizedBox(height: 18),
                if (_isRecurring) ...[
                  Text(
                    'Deposit day',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  _DateField(
                    icon: Icons.event_repeat_rounded,
                    label: 'Every month on day ${_recurringDay ?? '-'}',
                    onTap: _pickRecurringDay,
                  ),
                ] else ...[
                  Text('Date', style: TextStyle(color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  _DateField(
                    icon: Icons.calendar_today_rounded,
                    label:
                        '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Will be added to: '
                            '${_currentPeriodLabel(globalPeriod, firstHalfEndDay)}',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                CommonButton(
                  label: widget.isEditing ? 'Save Changes' : 'Add Income',
                  btnColor: AppColors.black,
                  labelColor: AppColors.white,
                  isLoading: actionsState.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared pill-bordered date/day field, matching ExpenseFormScreen's date
/// picker styling (primary-tinted fill + border, radius 14).
class _DateField extends StatelessWidget {
  const _DateField({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}