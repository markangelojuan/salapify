class BudgetLimits {
  BudgetLimits._();

  static const int freeMaxActiveCategories = 12;
  static const int premiumMaxActiveCategories = 100;

  static int maxActiveCategoriesFor({required bool isPremium}) {
    return isPremium ? premiumMaxActiveCategories : freeMaxActiveCategories;
  }
}