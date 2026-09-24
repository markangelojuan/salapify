import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';
import '../widgets/background_decoration.dart';
import '../widgets/auth_header.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  bool _isChecking = false;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        setState(() => _cooldownSeconds = 0);
      } else {
        setState(() => _cooldownSeconds -= 1);
      }
    });
  }

  Future<void> _resend() async {
    await ref.read(authControllerProvider.notifier).resendVerificationEmail();
    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    if (!state.hasError) {
      _startCooldown();
      CommonSnackbar.showSuccess(context, "Verification email sent.");
    }
  }

  Future<void> _checkVerified() async {
    setState(() => _isChecking = true);
    final verified = await ref
        .read(authControllerProvider.notifier)
        .checkEmailVerified();
    if (!mounted) return;
    setState(() => _isChecking = false);

    if (verified) {
      context.go('/home');
    } else {
      CommonSnackbar.showWarning(
        context,
        "Not verified yet — check your inbox (and spam).",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authRepositoryProvider).currentUser?.email ?? '';
    final authState = ref.watch(authControllerProvider);
    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) => CommonSnackbar.showError(context, error),
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          BackgroundDecoration(color: AppColors.primary),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Align(
                        alignment: Alignment.centerLeft,
                        child: AuthHeader(
                          title: const Text("Verify your email"),
                          subtitle: email.isEmpty
                              ? "We've sent you a verification link."
                              : "We've sent a verification link to $email.",
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(
                        begin: 0.15,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 48),
                  Text(
                    "Click the link in that email, then tap the button below.",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CommonButton(
                    label: "I've verified",
                    btnColor: AppColors.black,
                    labelColor: AppColors.white,
                    isLoading: _isChecking,
                    onPressed: _isChecking ? null : _checkVerified,
                  ),
                  const SizedBox(height: 12),
                  CommonButton(
                    label: _cooldownSeconds > 0
                        ? "Resend in ${_cooldownSeconds}s"
                        : "Resend email",
                    btnColor: AppColors.white,
                    labelColor: AppColors.black,
                    isLoading: authState.isLoading,
                    onPressed: _cooldownSeconds > 0 ? null : _resend,
                  ),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).signOut();
                      },
                      child: Text(
                        "Sign out",
                        style: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
