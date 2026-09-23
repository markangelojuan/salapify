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
      _usernameError = existingUid != null ? 'Username is already taken' : null;
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
      setState(() => _emailError = 'Email is already registered');
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            hint: "Enter your preferred username",
            maxCharacters: 18,
            textInputAction: TextInputAction.next,
            label: "Username",
            validator: (value) {
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
            },
          ),
          const SizedBox(height: 12),
          CommonTextField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            icon: Icons.mail_outline_rounded,
            maxCharacters: 255,
            hint: "Enter your email",
            label: "Email Address",
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!value.contains("@")) return "Enter a valid email";
              if (_emailError != null) return _emailError;
              return null;
            },
          ),
          const SizedBox(height: 12),
          CommonTextField(
            controller: _passwordController,
            textInputAction: TextInputAction.next,
            icon: Icons.lock_open_rounded,
            maxCharacters: 120,
            hint: "Enter your password",
            label: "Password",
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) return "Password is required";
              if (value.length < 6) return "Minimum 6 characters";
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
          const SizedBox(height: 12),
          CommonTextField(
            controller: _confirmPasswordController,
            textInputAction: TextInputAction.done,
            icon: Icons.lock_outline_rounded,
            maxCharacters: 120,
            hint: "Re-enter your password",
            label: "Confirm Password",
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != _passwordController.text) {
                return "Passwords do not match";
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
                    'I agree to the Terms of Service and Privacy Policy',
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
            label: "Sign Up",
            btnColor: AppColors.black,
            labelColor: AppColors.white,
            onPressed: _isChecked ? _submit : null,
            isLoading: authState.isLoading || _isCheckingUsername,
          ),
          const SizedBox(height: 12),
          CommonButton(
            label: "Cancel",
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
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 60,
          ),
          title: const Text("Terms & Privacy"),
          content: SizedBox(
            height: 360,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Terms of Service",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "By using Salapify, you agree to use the app responsibly "
                    "and provide accurate information. You are responsible "
                    "for your account and the information you enter.",
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Salapify collects information needed to provide your "
                    "account, budgeting, expense tracking, groups, and "
                    "bill-splitting features. We do not connect to your "
                    "bank accounts or financial accounts, and we do not "
                    "sell your personal information.",
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Shared Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "When you join groups or split bills, relevant information "
                    "such as your username, bills, and shares may be visible "
                    "to other members of those groups.",
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Important",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Salapify is a budgeting and organization tool, not a bank, "
                    "payment service, or financial adviser.",
                  ),

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
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "I agree to the Terms of Service and Privacy Policy.",
                          ),
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
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
