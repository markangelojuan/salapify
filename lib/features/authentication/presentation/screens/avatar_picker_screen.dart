import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/domain/entities/avatar_option.dart';
import 'package:salapify/features/authentication/presentation/controllers/avatar_controller.dart';

class AvatarPickerScreen extends ConsumerStatefulWidget {
  const AvatarPickerScreen({super.key});

  @override
  ConsumerState<AvatarPickerScreen> createState() => _AvatarPickerScreenState();
}

class _AvatarPickerScreenState extends ConsumerState<AvatarPickerScreen> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.42);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    // Guard against double-tap while a save is already in flight.
    if (ref.read(avatarControllerProvider).isLoading) return;

    final avatar = kAvatarOptions[_selectedIndex];
    await ref.read(avatarControllerProvider.notifier).selectAvatar(avatar.id);

    if (!mounted) return;
    final hasError = ref.read(avatarControllerProvider).hasError;
    if (hasError) return;

    if (context.canPop()) {
      // Opened from Account screen ("Change") — go back to it.
      context.pop();
    } else {
      // Reached via onboarding redirect (no screen to pop to) — go home.
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.watch(avatarControllerProvider);

    ref.listen<AsyncValue<void>>(avatarControllerProvider, (previous, next) {
      next.whenOrNull(error: (e, _) => CommonSnackbar.showError(context, e));
    });

    final selected = kAvatarOptions[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 130,
                        child: Lottie.asset('assets/lottie/sleeping_squirrel.json'),
                      ),
                      Text(
                        'Pick your money avatar',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can change this anytime',
                        style: TextStyle(color: AppColors.black.withOpacity(0.6)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: kAvatarOptions.length,
                          onPageChanged: (i) => setState(() => _selectedIndex = i),
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double scale = 1.0;
                                if (_pageController.position.haveDimensions) {
                                  final page = _pageController.page ?? index.toDouble();
                                  final diff = (page - index).abs();
                                  scale = (1 - (diff * 0.35)).clamp(0.65, 1.0);
                                }
                                return Center(
                                  child: Transform.scale(scale: scale, child: child),
                                );
                              },
                              child: _AvatarCircle(
                                avatar: kAvatarOptions[index],
                                isSelected: index == _selectedIndex,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          selected.name,
                          key: ValueKey(selected.id),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Spacer() only works with bounded/definite-height
                      // parents. Inside a scroll view the Column gets
                      // unbounded height, so we use a flexible min gap
                      // instead — it still pushes the button down on tall
                      // screens without throwing on short ones.
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 20,
                        ),
                        child: CommonButton(
                          label: 'Confirm',
                          btnColor: AppColors.black,
                          labelColor: AppColors.white,
                          onPressed: _confirm,
                          isLoading: avatarState.isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.avatar, required this.isSelected});
  final AvatarOption avatar;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 3,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: ClipOval(child: Image.asset(avatar.assetPath, fit: BoxFit.cover)),
    );
  }
}