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
  bool _isGoogleLoading = false;

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

  Future<void> _continueWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showForgotPasswordSheet() {

    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final capturedTheme = Theme.of(context);

    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    final dialogFormKey = GlobalKey<FormState>();
    bool isSending = false;
    bool emailSent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (sheetCtx) => Theme(
        data: capturedTheme,
        child: StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            Future<void> submit() async {
              if (!dialogFormKey.currentState!.validate()) return;

              setSheetState(() => isSending = true);
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .sendPasswordResetEmail(resetEmailController.text.trim());
                setSheetState(() {
                  isSending = false;
                  emailSent = true;
                });
              } catch (e) {
                setSheetState(() => isSending = false);
                if (sheetCtx.mounted) {
                  CommonSnackbar.showError(sheetCtx, e);
                }
              }
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
                ),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Reset your password",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (emailSent) ...[
                        Text(
                          "If an account exists for that email, a reset link is on its way. Check your inbox (and spam folder).",
                          style: TextStyle(color: colors.textPrimary),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CommonButton(
                            label: "Done",
                            btnColor: colors.textPrimary,
                            labelColor: colors.background,
                            onPressed: () => Navigator.pop(sheetCtx),
                          ),
                        ),
                      ] else ...[
                        Form(
                          key: dialogFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Enter your email address and we'll send you a link to reset your password.",
                                style: TextStyle(color: colors.textPrimary),
                              ),
                              const SizedBox(height: 16),
                              CommonTextField(
                                controller: resetEmailController,
                                icon: Icons.mail_outline_rounded,
                                hint: "Enter your email",
                                label: "Email Address",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is required";
                                  }
                                  final emailRegex = RegExp(
                                    r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(sheetCtx),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  side: BorderSide(color: colors.border),
                                  foregroundColor: colors.textPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CommonButton(
                                label: "Send link",
                                btnColor: colors.textPrimary,
                                labelColor: colors.background,
                                isLoading: isSending,
                                onPressed: isSending ? null : submit,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).then((_) => resetEmailController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;
    final authState = ref.watch(authControllerProvider);
    final isEmailSignInLoading = authState.isLoading && !_isGoogleLoading;

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
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(
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
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
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
                    color: colors.textSecondary,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 60.ms, duration: 300.ms)
              .slideY(
                begin: 0.1,
                end: 0,
                delay: 60.ms,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordSheet,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: colors.textPrimary,
              ),
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          CommonButton(
                label: "Sign In",
                btnColor: colors.textPrimary,
                labelColor: colors.background,
                isLoading: isEmailSignInLoading,
                onPressed: authState.isLoading ? null : _submit,
              )
              .animate()
              .fadeIn(delay: 120.ms, duration: 300.ms)
              .slideY(
                begin: 0.1,
                end: 0,
                delay: 120.ms,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(child: Divider(color: colors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Or continue with",
                  style: TextStyle(color: colors.textSecondary, fontSize: 13),
                ),
              ),
              Expanded(child: Divider(color: colors.border)),
            ],
          ),
          const SizedBox(height: 16),

          // --- OAuth option ---
          SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: authState.isLoading ? null : _continueWithGoogle,
                  icon: _isGoogleLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.textPrimary,
                          ),
                        )
                      : Image.asset(
                          'assets/images/google_logo.png',
                          height: 20,
                          width: 20,
                        ),
                  label: Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: colors.border),
                    foregroundColor: colors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 160.ms, duration: 300.ms)
              .slideY(
                begin: 0.1,
                end: 0,
                delay: 160.ms,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(color: colors.textPrimary),
              ),
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.signUp.name),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colors.textPrimary,
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Center(
            child: TextButton(
              onPressed: () {
                ref.read(guestModeProvider.notifier).enable();
                context.go('/home');
              },
              child: Text(
                "Continue as guest",
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}