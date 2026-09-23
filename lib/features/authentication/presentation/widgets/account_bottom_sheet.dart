import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/router/routes.dart';

Future<void> showEditUsernameSheet(
  BuildContext context,
  String currentUsername,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _EditUsernameSheet(currentUsername: currentUsername),
  );
}

Future<void> showDeleteAccountSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _DeleteAccountSheet(),
  );
}


class _AccountBottomSheetScaffold extends StatelessWidget {
  const _AccountBottomSheetScaffold({
    required this.title,
    required this.colors,
    required this.child,
    required this.actions,
  });

  final String title;
  final AppColorsExt colors;
  final Widget child;

  /// Buttons in priority order, top to bottom. Rendered full width.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: child,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      actions[i],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Primary filled action button — same look as BudgetFilterSheet's Apply
/// button (colors.textPrimary fill), with an optional override for
/// destructive actions (red).
Widget _primaryButton({
  required AppColorsExt colors,
  required VoidCallback? onPressed,
  required Widget child,
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  return FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: backgroundColor ?? colors.textPrimary,
      foregroundColor: foregroundColor ?? colors.background,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    onPressed: onPressed,
    child: child,
  );
}

/// Secondary outlined action button (Cancel / Back).
Widget _secondaryButton({
  required VoidCallback? onPressed,
  required Widget child,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    onPressed: onPressed,
    child: child,
  );
}

enum _DeleteStep { confirmWord, reauth }

class _DeleteAccountSheet extends ConsumerStatefulWidget {
  const _DeleteAccountSheet();

  @override
  ConsumerState<_DeleteAccountSheet> createState() =>
      _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends ConsumerState<_DeleteAccountSheet> {
  static const _confirmWord = 'Save small sums, see savings soar';

  final _wordController = TextEditingController();
  final _passwordController = TextEditingController();

  _DeleteStep _step = _DeleteStep.confirmWord;
  bool _canProceed = false;
  bool _isBusy = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _wordController.addListener(() {
      setState(() {
        _canProceed = _wordController.text.trim().toLowerCase() ==
            _confirmWord.toLowerCase();
      });
    });
    // Rebuilds so the delete button's empty-password guard reflects typing.
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _wordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? get _providerId =>
      ref.read(authRepositoryProvider).currentUserProviderId;

  bool get _isGoogle => _providerId == 'google.com';

  bool get _canSubmitReauth =>
      !_isBusy && (_isGoogle || _passwordController.text.trim().isNotEmpty);

  Future<void> _handleFinalDelete() async {
    setState(() {
      _isBusy = true;
      _errorText = null;
    });

    final controller = ref.read(authControllerProvider.notifier);

    if (_isGoogle) {
      await controller.deleteAccountWithGoogle();
    } else {
      await controller.deleteAccountWithPassword(_passwordController.text);
    }

    final state = ref.read(authControllerProvider);
    if (!mounted) return;

    state.whenOrNull(
      error: (error, _) {
        if (error is ReauthCancelledException) {
          // User backed out of the Google picker — just reset, no message,
          // sheet stays open so they can try again.
          setState(() => _isBusy = false);
          return;
        }
        setState(() {
          _isBusy = false;
          _errorText = error is WrongPasswordException
              ? 'Incorrect password. Please try again.'
              : 'Something went wrong. Please try again.';
        });
      },
      data: (_) {
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        context.goNamed(AppRoutes.signIn.name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final isGoogle = _isGoogle;

    return PopScope(
      canPop: !_isBusy,
      child: _AccountBottomSheetScaffold(
        title: 'Delete account',
        colors: colors,
        child: _step == _DeleteStep.confirmWord
            ? _buildConfirmWordStep(colors)
            : _buildReauthStep(colors, isGoogle),
        actions: _step == _DeleteStep.confirmWord
            ? [
                _primaryButton(
                  colors: colors,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  onPressed: _canProceed
                      ? () => setState(() => _step = _DeleteStep.reauth)
                      : null,
                  child: const Text('Continue'),
                ),
                _secondaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ]
            : [
                _primaryButton(
                  colors: colors,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  onPressed: _canSubmitReauth ? _handleFinalDelete : null,
                  child: _isBusy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isGoogle
                              ? 'Verify with Google'
                              : 'Delete permanently',
                        ),
                ),
                _secondaryButton(
                  onPressed: _isBusy
                      ? null
                      : () => setState(() => _step = _DeleteStep.confirmWord),
                  child: const Text('Back'),
                ),
              ],
      ),
    );
  }

  Widget _buildConfirmWordStep(AppColorsExt colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This action is permanent and cannot be undone. All your data, '
          'transactions, and settings will be permanently deleted.',
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Text(
          'Type "$_confirmWord" to confirm',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _wordController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: _confirmWord,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildReauthStep(AppColorsExt colors, bool isGoogle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isGoogle
              ? 'For your security, please confirm your identity with Google before we delete your account.'
              : 'For your security, please enter your password to confirm.',
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
        if (!isGoogle) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: true,
            enabled: !_isBusy,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Text(_errorText!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}

class _EditUsernameSheet extends ConsumerStatefulWidget {
  const _EditUsernameSheet({required this.currentUsername});
  final String currentUsername;

  @override
  ConsumerState<_EditUsernameSheet> createState() => _EditUsernameSheetState();
}

class _EditUsernameSheetState extends ConsumerState<_EditUsernameSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  String? _usernameError;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername);
    _controller.addListener(() {
      if (_usernameError != null) setState(() => _usernameError = null);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return "Username is required";
    if (value != value.trim()) return "No leading or trailing spaces";
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
      return "Must start with a letter";
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return "Only letters, numbers, and underscores allowed";
    }
    final letterCount = RegExp(r'[a-zA-Z]').allMatches(value).length;
    if (letterCount < 3) return "Minimum 3 letters";
    final digitCount = RegExp(r'[0-9]').allMatches(value).length;
    if (digitCount > 3) return "Maximum 3 numbers";
    if (_usernameError != null) return _usernameError;
    return null;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final newUsername = _controller.text.trim();
    if (newUsername == widget.currentUsername) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isSubmitting = true);

    await ref.read(authControllerProvider.notifier).updateUsername(newUsername);

    if (!mounted) return;

    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        setState(() {
          _isSubmitting = false;
          if (error is UsernameTakenException) {
            _usernameError = 'Username is already taken';
            _formKey.currentState!.validate();
          }
        });
      },
      data: (_) {
        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return PopScope(
      canPop: !_isSubmitting,
      child: _AccountBottomSheetScaffold(
        title: 'Change username',
        colors: colors,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            enabled: !_isSubmitting,
            maxLength: 20,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: _validateUsername,
          ),
        ),
        actions: [
          _primaryButton(
            colors: colors,
            onPressed: _isSubmitting ? null : _handleSave,
            child: _isSubmitting
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.background,
                    ),
                  )
                : const Text('Save'),
          ),
          _secondaryButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}