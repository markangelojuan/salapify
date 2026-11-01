import 'package:salapify/core/localization/localized_exception.dart';
import 'package:salapify/l10n/app_localizations.dart';

class CategoryLimitExceededException implements LocalizedException {
  const CategoryLimitExceededException(this.limit);
  final int limit;

  @override
  String localizedMessage(AppLocalizations l10n) =>
      l10n.limitReachedCategories(limit);

  @override
  String toString() => 'CategoryLimitExceededException(limit: $limit)';
}