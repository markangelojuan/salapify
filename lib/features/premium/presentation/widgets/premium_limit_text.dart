import 'package:salapify/features/premium/domain/entities/premium_limit.dart';
import 'package:salapify/l10n/app_localizations.dart';

extension PremiumLimitText on PremiumLimit {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    PremiumLimit.categories => l10n.premiumLimitCategories,
    PremiumLimit.groups => l10n.premiumLimitGroups,
    PremiumLimit.bills => l10n.premiumLimitBills,
  };
}