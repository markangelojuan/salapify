import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/features/authentication/presentation/widgets/sign_in_form.dart';
import '../widgets/background_decoration.dart';
import '../widgets/auth_header.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          BackgroundDecoration(color: AppColors.primary),
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
                            title: "Kumusta",
                            subtitle:
                                "Enter your credentials to access your account",
                          ),
                        ),
                        const SizedBox(height: 48),
                        const SignInForm(),
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
