import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/presentation/widgets/sign_up_form.dart';
import '../widgets/background_decoration.dart';
import '../widgets/auth_header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          BackgroundDecoration(
            color: AppColors.primary,
            variant: BackgroundVariant.signUp,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 28,
                      right: 28,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AuthHeader(
                            title: "Maligayang pagdating",
                            subtitle: "Create an account to get started",
                          ),
                        ).animate().fadeIn(
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ).slideY(
                              begin: 0.15,
                              end: 0,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: 48),
                        const SignUpForm()
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              delay: 200.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}