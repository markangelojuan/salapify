import 'package:flutter/material.dart';
import 'package:salapify/core/localization/app_languages.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/l10n/app_localizations.dart';

/// Shared by Settings and the first-launch prompt.
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({
    super.key,
    required this.selected,
    required this.onSelect,
    this.description,
  });

  final Locale? selected;
  final ValueChanged<Locale?> onSelect;

  /// Optional hint rendered under the title.
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final options = <(Locale?, String)>[
      (null, l10n.languageSystemDefault),
      for (final l in supportedLanguages) (l.locale, l.nativeName),
    ];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                description == null ? 8 : 4,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.languageChoose,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  for (final (locale, label) in options)
                    InkWell(
                      onTap: () => onSelect(locale),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (locale == selected)
                              const Icon(
                                Icons.check_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}