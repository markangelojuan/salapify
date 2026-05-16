import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
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

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .createUserWithEmailAndPassword(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) => CommonSnackbar.showError(context, error),
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
            label: "Username",
            validator: (value) {
              if (value == null || value.isEmpty) return "Username is required";
              if (value.length < 3) return "Minimum 3 characters";
              return null;
            },
          ),
          const SizedBox(height: 18),
          CommonTextField(
            controller: _emailController,
            icon: Icons.mail_outline_rounded,
            hint: "Enter your email",
            label: "Email Address",
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!value.contains("@")) return "Enter a valid email";
              return null;
            },
          ),
          const SizedBox(height: 18),
          CommonTextField(
            controller: _passwordController,
            icon: Icons.lock_open_rounded,
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
          const SizedBox(height: 18),
          CommonTextField(
            controller: _confirmPasswordController,
            icon: Icons.lock_outline_rounded,
            hint: "Re-enter your password",
            label: "Confirm Password",
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
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
              GestureDetector(
                onTap: () => _showPolicyDialog(),
                child: Text(
                  'I agree to the Terms of Service and Privacy Policy',
                  style: TextStyle(
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CommonButton(
            label: "Sign Up",
            btnColor: AppColors.black,
            labelColor: AppColors.white,
            onPressed: _isChecked ? _submit : null,
            isLoading: authState.isLoading,
          ),
          const SizedBox(height: 12),
          CommonButton(
            label: "Cancel",
            btnColor: AppColors.white,
            labelColor: AppColors.black,
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: 24),
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
            vertical: 80,
          ),
          title: const Text("Terms & Privacy Policy"),
          content: SizedBox(
            height: 300,
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
                    "1. Acceptance — By using Salapify, you agree to these terms. If you disagree, please do not use the app.",
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "2. User Responsibilities — You are responsible for keeping your credentials confidential and all activities under your account.",
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "3. Changes — We may update these terms at any time. Continued use means acceptance of the new terms.",
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "1. Data Collection — We collect your name, email, and financial data solely to provide budgeting services.",
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "2. Data Sharing — We do not sell your data to third parties.",
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "3. Security — We use industry-standard measures to protect your data, though no transmission is 100% secure.",
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          setState(() => _isChecked = value!);
                          setDialogState(() {});
                        },
                      ),
                      Expanded(
                        child: Text(
                          "I agree to the Terms of Service and Privacy Policy",
                          softWrap: true,
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
