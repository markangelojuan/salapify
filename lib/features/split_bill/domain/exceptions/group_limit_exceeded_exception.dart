import 'package:salapify/core/localization/localized_exception.dart';
import 'package:salapify/l10n/app_localizations.dart';

class GroupLimitExceededException implements LocalizedException {
  const GroupLimitExceededException(this.limit);
  final int limit;

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorGroupLimit(limit);

  @override
  String toString() => 'You can only have $limit active groups on the free plan';
}

class MaxGroupMembersExceededException implements LocalizedException {
  const MaxGroupMembersExceededException(this.limit);
  final int limit;

  @override
  String localizedMessage(AppLocalizations l10n) => l10n.errorMaxMembers(limit);

  @override
  String toString() => 'Groups can have at most $limit members';
}