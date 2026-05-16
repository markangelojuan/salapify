import 'package:flutter/material.dart';
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
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AuthHeader(
                            title: "Maligayang pagdating",
                            subtitle: "Create an account to get started",
                          ),
                        ),
                        const SizedBox(height: 48),
                        const SignUpForm(),
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
