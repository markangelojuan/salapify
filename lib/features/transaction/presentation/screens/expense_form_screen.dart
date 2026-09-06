import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/presentation/constants/category_icons.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/transaction/domain/entities/transaction_entry.dart';
import 'package:salapify/features/transaction/presentation/controllers/transaction_controller.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({super.key, this.existingTransaction});

  /// Null = add mode. Non-null = edit mode.
  final TransactionEntry? existingTransaction;

  bool get isEditing => existingTransaction != null;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  String? _selectedCategoryId;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingTransaction;
    _amountController = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(2) : '',
    );
    _noteController = TextEditingController(text: existing?.note ?? '');
    _selectedCategoryId = existing?.categoryId;
    _date = existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final amount = double.parse(_amountController.text.trim());
    final note = _noteController.text.trim();
    final actions = ref.read(transactionActionsProvider.notifier);

    if (widget.isEditing) {
      final updated = widget.existingTransaction!.copyWith(
        categoryId: _selectedCategoryId!,
        amount: amount,
        note: note.isEmpty ? null : note,
        date: _date,
      );
      await actions.updateTransaction(updated);
    } else {
      final newTransaction = TransactionEntry(
        id: const Uuid().v4(),
        categoryId: _selectedCategoryId!,
        amount: amount,
        note: note.isEmpty ? null : note,
        date: _date,
        createdAt: DateTime.now(),
      );
      await actions.addTransaction(newTransaction);
    }

    if (mounted) context.pop();
  }

  List<BudgetCategory> _visibleCategories(List<BudgetCategory> all) {
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final firstHalfEndDay =
        ref.watch(firstHalfEndDaySettingProvider).value ?? 15;
    final now = DateTime.now();

    final active = all
        .where(
          (c) =>
              !c.isDeleted &&
              c.isActiveFor(
                globalPeriod: globalPeriod,
                firstHalfEndDay: firstHalfEndDay,
                now: now,
              ),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return active;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(budgetCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Expense' : 'Add Expense'),
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
                Text('Category', style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                categoriesAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Failed to load categories: $e'),
                  data: (categories) =>
                      _CategoryPicker(
                        categories: _visibleCategories(categories),
                        selectedId: _selectedCategoryId,
                        onSelected: (id) =>
                            setState(() => _selectedCategoryId = id),
                      ),
                ),
                const SizedBox(height: 18),
                Text('Date', style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                CommonTextField(
                  controller: _noteController,
                  icon: Icons.notes_rounded,
                  hint: 'e.g. Coffee with a friend',
                  label: 'Note (optional)',
                ),
                const SizedBox(height: 28),
                CommonButton(
                  label: widget.isEditing ? 'Save Changes' : 'Add Expense',
                  btnColor: AppColors.black,
                  labelColor: AppColors.white,
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

/// Horizontally scrollable chip picker for selecting a category, reusing
/// existing category icons/names rather than re-listing everything as a
/// plain dropdown.
class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<BudgetCategory> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Text('No categories yet — add one from the Budget tab.');
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final selected = category.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(category.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CategoryIcons.iconFor(category.iconName),
                  size: 16,
                  color: selected ? Colors.white : AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}