import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/split_bill/data/repositories/report_repository.dart';

class ReportArgs {
  const ReportArgs({
    required this.groupId,
    required this.reportedUserId,
    required this.reportedUsername,
  });

  final String groupId;
  final String reportedUserId;
  final String reportedUsername;
}

class ReportUserScreen extends ConsumerStatefulWidget {
  const ReportUserScreen({super.key, required this.args});

  final ReportArgs args;

  @override
  ConsumerState<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends ConsumerState<ReportUserScreen> {
  final _noteController = TextEditingController();
  bool _isSubmitting = false;
  String? _noteError;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _noteError = _noteController.text.trim().isEmpty
          ? 'Please describe the issue'
          : null;
    });
    if (_noteError != null) return;

    final currentUid = ref.read(currentUserProvider)?.uid;
    if (currentUid == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(reportRepositoryProvider).submitReport(
            reporterId: currentUid,
            reportedUserId: widget.args.reportedUserId,
            reportedUsername: widget.args.reportedUsername,
            groupId: widget.args.groupId,
            note: _noteController.text.trim(),
          );
      if (!mounted) return;
      CommonSnackbar.showSuccess(context, 'Report submitted');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      CommonSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Report User')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Reporting', style: TextStyle(color: colors.textPrimary)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.05),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.15),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.args.reportedUsername,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'What\'s going on?',
              style: TextStyle(color: colors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Be as specific as possible — include what happened clearly.',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.05),
                border: Border.all(
                  color: _noteError != null
                      ? colors.error
                      : colors.primary.withValues(alpha: 0.15),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextFormField(
                controller: _noteController,
                maxLines: 5,
                maxLength: 500,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                  hintText: 'Describe what happened...',
                  hintStyle: TextStyle(color: colors.textSecondary),
                  counterText: '',
                ),
                onChanged: (_) {
                  if (_noteError != null) setState(() => _noteError = null);
                },
              ),
            ),
            if (_noteError != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _noteError!,
                  style: TextStyle(fontSize: 12, color: colors.error),
                ),
              ),
            ],
            const SizedBox(height: 28),
            CommonButton(
              label: 'Submit Report',
              btnColor: colors.textPrimary,
              labelColor: colors.background,
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}