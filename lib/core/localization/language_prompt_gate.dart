import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salapify/core/localization/locale_controller.dart';
import 'package:salapify/core/widgets/language_picker_sheet.dart';
import 'package:salapify/l10n/app_localizations.dart';

const _promptShownKey = 'language_prompt_shown';

/// Shows the language picker once, on the first launch after install,
/// whichever screen the router lands on first.
class LanguagePromptGate extends ConsumerStatefulWidget {
  const LanguagePromptGate({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  ConsumerState<LanguagePromptGate> createState() => _LanguagePromptGateState();
}

class _LanguagePromptGateState extends ConsumerState<LanguagePromptGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShow());
  }

  Future<void> _maybeShow() async {
    final prefs = await SharedPreferences.getInstance();

    // Skip if already shown, or if the user already has a saved language
    // (e.g. existing users updating the app).
    final alreadyHandled =
        (prefs.getBool(_promptShownKey) ?? false) ||
        prefs.containsKey(LocaleController.prefsKey);
    if (alreadyHandled) return;

    // GoRouter builds its Navigator asynchronously, so wait for it
    // (up to ~3s) instead of assuming it exists on the first frame.
    BuildContext? navContext;
    for (var i = 0; i < 30; i++) {
      navContext = widget.navigatorKey.currentContext;
      if (navContext != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }
    if (navContext == null || !navContext.mounted) return;

    // Only mark as shown once we're really about to show it, so a failed
    // attempt retries next launch. Setting it before awaiting the sheet means
    // dismissing or killing the app never brings it back.
    await prefs.setBool(_promptShownKey, true);
    if (!navContext.mounted) return;

    final hint = AppLocalizations.of(navContext).languageChangeLaterHint;

    await showModalBottomSheet<void>(
      context: navContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => LanguagePickerSheet(
        selected: ref.read(localeControllerProvider),
        description: hint,
        onSelect: (l) {
          ref.read(localeControllerProvider.notifier).set(l);
          Navigator.pop(sheetCtx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}