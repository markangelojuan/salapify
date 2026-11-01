import 'package:salapify/core/localization/localized_exception.dart';
import 'package:salapify/l10n/app_localizations.dart';

class BillLimitExceededException implements LocalizedException {
  const BillLimitExceededException(this.limit);
  final int limit;

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorBillLimit(limit);

  @override
  String toString() =>
      'This group has reached its limit of $limit ${limit == 1 ? 'bill' : 'bills'}';
}