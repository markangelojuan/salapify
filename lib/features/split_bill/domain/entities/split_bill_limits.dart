class SplitBillLimits {
  SplitBillLimits._();

  static const int freeMaxActiveGroups = 1;
  static const int premiumMaxActiveGroups = 10;

  static const int freeMaxBillsPerGroup = 2;
  static const int premiumMaxBillsPerGroup = 50;

  static const int maxGroupMembers = 21;

  static int maxActiveGroupsFor({required bool isPremium}) {
    return isPremium ? premiumMaxActiveGroups : freeMaxActiveGroups;
  }

  static int maxBillsPerGroupFor({required bool isPremium}) {
    return isPremium ? premiumMaxBillsPerGroup : freeMaxBillsPerGroup;
  }
}