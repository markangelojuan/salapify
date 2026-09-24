class BudgetLimits {
  BudgetLimits._();

  static const int freeMaxActiveCategories = 9;
  static const int premiumMaxActiveCategories = 50;

  static int maxActiveCategoriesFor({required bool isPremium}) {
    return isPremium ? premiumMaxActiveCategories : freeMaxActiveCategories;
  }
}