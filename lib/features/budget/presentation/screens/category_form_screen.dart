import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/features/budget/domain/entities/budget_category.dart';
import 'package:salapify/features/budget/domain/entities/budget_category_type.dart';
import 'package:salapify/features/budget/domain/entities/budget_frequency.dart';
import 'package:salapify/features/budget/presentation/controllers/budget_controller.dart';
import 'package:salapify/features/budget/presentation/constants/category_icons.dart';
import 'package:salapify/features/settings/domain/budgeting_period.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/settings/domain/currency.dart';
import 'package:flutter/services.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  const CategoryFormScreen({super.key, this.existingCategory});

  /// Null = add mode. Non-null = edit mode.
  final BudgetCategory? existingCategory;

  bool get isEditing => existingCategory != null;

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  late BudgetCategoryType _type;
  late BudgetFrequency _frequency;
  BudgetPeriod? _period;
  late String _iconKey;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingCategory;
    final globalPeriod =
        ref.read(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;

    _nameController.text = existing?.name ?? '';
    _amountController.text = existing?.amount.toString() ?? '';
    _type = existing?.type ?? BudgetCategoryType.variable;
    _frequency =
        existing?.frequency ??
        (globalPeriod == BudgetingPeriod.biMonthly
            ? BudgetFrequency.biMonthly
            : BudgetFrequency.monthly);
    _period =
        existing?.period ??
        (globalPeriod == BudgetingPeriod.biMonthly ? BudgetPeriod.both : null);
    _iconKey = existing?.iconName ?? CategoryIcons.keys.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final globalPeriod =
        ref.read(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final now = DateTime.now();

    final category = BudgetCategory(
      id: widget.existingCategory?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      amount: double.parse(_amountController.text.trim()),
      frequency: _frequency,
      period: globalPeriod == BudgetingPeriod.biMonthly ? _period : null,
      iconName: _iconKey,
      sortOrder: widget.existingCategory?.sortOrder ?? 0,
      isCompleted: widget.existingCategory?.isCompleted ?? false,
      createdAt: widget.existingCategory?.createdAt ?? now,
      updatedAt: widget.isEditing ? now : null,
    );

    final actions = ref.read(budgetActionsProvider.notifier);
    final future = widget.isEditing
        ? actions.updateCategory(category)
        : actions.addCategory(category);

    future.then((_) {
      final state = ref.read(budgetActionsProvider);
      if (!context.mounted) return;
      if (state.hasError) {
        CommonSnackbar.showError(context, state.error!);
      } else {
        context.pop();
      }
    });
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${widget.existingCategory!.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final actions = ref.read(budgetActionsProvider.notifier);
    await actions.deleteCategory(widget.existingCategory!);

    final state = ref.read(budgetActionsProvider);
    if (state.hasError) {
      if (mounted) CommonSnackbar.showError(context, state.error!);
    } else if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalPeriod =
        ref.watch(budgetingPeriodSettingProvider).value ??
        BudgetingPeriod.monthly;
    final actionsState = ref.watch(budgetActionsProvider);
    final currency =
        ref.watch(currencySettingProvider).value ?? AppCurrency.php;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Category' : 'Add Category'),
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
                  controller: _nameController,
                  icon: Icons.label_outline_rounded,
                  hint: 'e.g. Groceries',
                  label: 'Category Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                CommonTextField(
                  controller: _amountController,
                  icon: Icons.attach_money_rounded,
                  prefixText: currency.symbol,
                  hint: '0.00',
                  label: 'Amount (${currency.symbol})',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
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
                SegmentedButton<BudgetCategoryType>(
                  segments: const [
                    ButtonSegment(
                      value: BudgetCategoryType.fixed,
                      label: Text('Fixed'),
                    ),
                    ButtonSegment(
                      value: BudgetCategoryType.variable,
                      label: Text('Variable'),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selection) =>
                      setState(() => _type = selection.first),
                ),
                const SizedBox(height: 18),
                Text('Repeat', style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                _buildFrequencyOptions(globalPeriod),
                const SizedBox(height: 18),
                Text('Icon', style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                _buildIconPicker(),
                const SizedBox(height: 28),
                CommonButton(
                  label: widget.isEditing ? 'Save Changes' : 'Add Category',
                  btnColor: AppColors.black,
                  labelColor: AppColors.white,
                  isLoading: actionsState.isLoading,
                  onPressed: _submit,
                ),
                if (widget.isEditing) ...[
                  const SizedBox(height: 12),
                  CommonButton(
                    label: "Delete Category",
                    btnColor: AppColors.white,
                    labelColor: Colors.red,
                    onPressed: _confirmDelete,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyOptions(BudgetingPeriod globalPeriod) {
    if (globalPeriod == BudgetingPeriod.monthly) {
      return SegmentedButton<BudgetFrequency>(
        segments: const [
          ButtonSegment(
            value: BudgetFrequency.monthly,
            label: Text('Every month'),
          ),
          ButtonSegment(value: BudgetFrequency.once, label: Text('Once')),
        ],
        selected: {_frequency},
        onSelectionChanged: (selection) =>
            setState(() => _frequency = selection.first),
      );
    }

    // biMonthly global setting
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<BudgetFrequency>(
          segments: const [
            ButtonSegment(
              value: BudgetFrequency.biMonthly,
              label: Text('Every period'),
            ),
            ButtonSegment(value: BudgetFrequency.once, label: Text('Once')),
          ],
          selected: {_frequency},
          onSelectionChanged: (selection) => setState(() {
            _frequency = selection.first;
            if (_frequency == BudgetFrequency.once) {
              _period = null;
            } else {
              _period ??= BudgetPeriod.both;
            }
          }),
        ),
        if (_frequency == BudgetFrequency.biMonthly) ...[
          const SizedBox(height: 12),
          SegmentedButton<BudgetPeriod>(
            segments: const [
              ButtonSegment(
                value: BudgetPeriod.both,
                label: Text('Both halves'),
              ),
              ButtonSegment(
                value: BudgetPeriod.firstHalf,
                label: Text('First half'),
              ),
              ButtonSegment(
                value: BudgetPeriod.secondHalf,
                label: Text('Second half'),
              ),
            ],
            selected: {_period ?? BudgetPeriod.both},
            onSelectionChanged: (selection) =>
                setState(() => _period = selection.first),
          ),
        ],
      ],
    );
  }

  Widget _buildIconPicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: CategoryIcons.keys.map((key) {
        final selected = key == _iconKey;
        return GestureDetector(
          onTap: () => setState(() => _iconKey = key),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.1),
            child: Icon(
              CategoryIcons.iconFor(key),
              color: selected ? AppColors.white : AppColors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
