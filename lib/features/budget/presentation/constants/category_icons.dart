import 'package:flutter/material.dart';

/// Curated set of icons available for budget categories.
/// Keys are stored in the database (BudgetCategoryRow.iconName / BudgetCategory.iconName).
/// Do not rename these keys once used in production — it will break existing data.
class CategoryIcons {
  CategoryIcons._();

  static const Map<String, IconData> _icons = {
    'food': Icons.restaurant_rounded,
    'groceries': Icons.local_grocery_store_rounded,
    'transport': Icons.directions_car_rounded,
    'utilities': Icons.bolt_rounded,
    'rent': Icons.home_rounded,
    'internet': Icons.wifi_rounded,
    'subscription': Icons.subscriptions_rounded,
    'health': Icons.local_hospital_rounded,
    'shopping': Icons.shopping_bag_rounded,
    'entertainment': Icons.movie_rounded,
    'education': Icons.school_rounded,
    'savings': Icons.savings_rounded,
    'insurance': Icons.shield_rounded,
    'debt': Icons.credit_card_rounded,
    'gift': Icons.card_giftcard_rounded,
    'travel': Icons.flight_rounded,
    'pets': Icons.pets_rounded,
    'other': Icons.category_rounded,
  };

  static IconData iconFor(String key) {
    return _icons[key] ?? _icons['other']!;
  }

  static List<String> get keys => _icons.keys.toList();
}