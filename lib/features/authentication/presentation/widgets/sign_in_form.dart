import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:salapify/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/features/authentication/presentation/controllers/guest_controller.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .signInWithEmailAndPassword(email: email, password: password);
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
            controller: _emailController,
            icon: Icons.mail_outline_rounded,
            hint: "Enter your email",
            label: "Email Address",
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return "Enter a valid email";
              }
              return null;
            },
          ).animate().fadeIn(duration: 300.ms).slideY(
                begin: 0.1,
                end: 0,
                duration: 300.ms,
                curve: Curves.easeOut,
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
          ).animate().fadeIn(delay: 60.ms, duration: 300.ms).slideY(
                begin: 0.1,
                end: 0,
                delay: 60.ms,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 24),
          CommonButton(
            label: "Sign In",
            btnColor: AppColors.black,
            labelColor: AppColors.white,
            isLoading: authState.isLoading,
            onPressed: _submit,
          ).animate().fadeIn(delay: 120.ms, duration: 300.ms).slideY(
                begin: 0.1,
                end: 0,
                delay: 120.ms,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {
                ref.read(guestModeProvider.notifier).enable();
                context.go('/home');
              },
              child: const Text("Continue as guest"),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text("OR", style: TextStyle(color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.signUp.name),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}