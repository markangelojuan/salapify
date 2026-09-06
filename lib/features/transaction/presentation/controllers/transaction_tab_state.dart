import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_tab_state.g.dart';

enum TransactionTab { expenses, income }

/// Tracks which sub-tab is active inside TransactionScreen, so HomeScreen's
/// shared FAB (which lives outside the tab's own widget tree) knows whether
/// tapping it should add an expense or an income entry.
@Riverpod(keepAlive: true)
class TransactionTabState extends _$TransactionTabState {
  @override
  TransactionTab build() => TransactionTab.expenses;

  void set(TransactionTab tab) => state = tab;
}