import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/authentication/domain/exceptions/auth_exceptions.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:salapify/l10n/app_localizations.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isChecked = false;
  bool _isCheckingUsername = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _usernameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
    _usernameController.addListener(() {
      if (_usernameError != null) setState(() => _usernameError = null);
    });
    _emailController.addListener(() {
      if (_emailError != null) setState(() => _emailError = null);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Pre-check username availability before attempting account creation.
    setState(() => _isCheckingUsername = true);
    final existingUid = await ref
        .read(userRepositoryProvider)
        .findUidByUsername(username);
    if (!mounted) return;
    setState(() {
      _isCheckingUsername = false;
      _usernameError = existingUid != null ? l10n.errorUsernameTaken : null;
    });
    if (existingUid != null) {
      _formKey.currentState!.validate();
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
          username: username,
        );
    if (!mounted) return;

    // Email uniqueness is only known after the create attempt.
    final error = ref.read(authControllerProvider).error;
    if (error is EmailAlreadyInUseException) {
      setState(() => _emailError = l10n.errorEmailRegistered);
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          // Username/email duplicate errors are shown inline under their
          // fields instead of a snackbar.
          if (error is UsernameTakenException ||
              error is EmailAlreadyInUseException) {
            return;
          }
          CommonSnackbar.showError(context, error);
        },
      );
    });
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextField(
            controller: _usernameController,
            icon: Icons.alternate_email_rounded,
            hint: l10n.authUsernameHint,
            maxCharacters: 18,
            textInputAction: TextInputAction.next,
            label: l10n.authUsernameLabel,
            validator: (value) {
              if (value == null || value.isEmpty)
                return l10n.authUsernameRequired;
              if (value != value.trim()) return l10n.authUsernameNoSpaces;
              if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
                return l10n.authUsernameStartLetter;
              }
              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                return l10n.authUsernameAllowedChars;
              }
              final letterCount = RegExp(r'[a-zA-Z]').allMatches(value).length;
              if (letterCount < 3) return l10n.authUsernameMinLetters;
              final digitCount = RegExp(r'[0-9]').allMatches(value).length;
              if (digitCount > 3) return l10n.authUsernameMaxNumbers;
              if (_usernameError != null) return _usernameError;
              return null;
            },
          ),
          const SizedBox(height: 10),
          CommonTextField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            icon: Icons.mail_outline_rounded,
            maxCharacters: 255,
            hint: l10n.authEmailHint,
            label: l10n.authEmailLabel,
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.authEmailRequired;
              if (!value.contains("@")) return l10n.authEmailInvalid;
              if (_emailError != null) return _emailError;
              return null;
            },
          ),
          const SizedBox(height: 10),
          CommonTextField(
            controller: _passwordController,
            textInputAction: TextInputAction.next,
            icon: Icons.lock_open_rounded,
            maxCharacters: 120,
            hint: l10n.authPasswordPinHint,
            label: l10n.authPasswordPinLabel,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty)
                return l10n.authPasswordRequired;
              if (value.length < 6) return l10n.authPasswordMinLength;
              return null;
            },
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 20,
                color: AppColors.background,
              ),
            ),
          ),
          const SizedBox(height: 10),
          CommonTextField(
            controller: _confirmPasswordController,
            textInputAction: TextInputAction.done,
            icon: Icons.lock_outline_rounded,
            maxCharacters: 120,
            hint: l10n.authConfirmPasswordHint,
            label: l10n.authConfirmPasswordLabel,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.authConfirmPasswordRequired;
              }
              if (value != _passwordController.text) {
                return l10n.authPasswordsMismatch;
              }
              return null;
            },
            suffix: IconButton(
              onPressed: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              ),
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 20,
                color: AppColors.background,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                visualDensity: VisualDensity.compact,
                onChanged: (value) => setState(() => _isChecked = value!),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showPolicyDialog(),
                  child: Text(
                    l10n.authAgreeTerms,
                    softWrap: true,
                    style: TextStyle(
                      color: AppColors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          CommonButton(
            label: l10n.authSignUp,
            btnColor: AppColors.black,
            labelColor: AppColors.white,
            onPressed: _isChecked ? _submit : null,
            isLoading: authState.isLoading || _isCheckingUsername,
          ),
          const SizedBox(height: 12),
          CommonButton(
            label: l10n.commonCancel,
            btnColor: AppColors.white,
            labelColor: AppColors.black,
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showPolicyDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 60,
          ),
          title: Text(l10n.termsDialogTitle),
          content: SizedBox(
            height: 360,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.termsServiceHeading,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.termsServiceBody),

                  const SizedBox(height: 16),

                  Text(
                    l10n.termsPrivacyHeading,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.termsPrivacyBody),

                  const SizedBox(height: 16),

                  Text(
                    l10n.termsSharedHeading,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.termsSharedBody),

                  const SizedBox(height: 16),

                  Text(
                    l10n.termsImportantHeading,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.termsImportantBody),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          // Update the actual form state.
                          setState(() {
                            _isChecked = value ?? false;
                          });

                          // Update the checkbox inside the dialog immediately.
                          setDialogState(() {});
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(l10n.authAgreeTerms),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.commonClose),
            ),
          ],
        ),
      ),
    );
  }
}
