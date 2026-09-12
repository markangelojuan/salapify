import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/settings/presentation/controllers/settings_controller.dart';
import 'package:salapify/features/split_bill/data/providers/split_bill_providers.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/features/split_bill/presentation/widgets/activity_feed_view.dart';
import 'package:salapify/features/split_bill/presentation/widgets/balance_summary_card.dart';
import 'package:salapify/features/split_bill/presentation/widgets/bills_carousel.dart';
import 'package:salapify/features/split_bill/presentation/widgets/message_input.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/settings/domain/currency.dart';

class SplitGroupDetailScreen extends ConsumerStatefulWidget {
  const SplitGroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<SplitGroupDetailScreen> createState() =>
      _SplitGroupDetailScreenState();
}

class _SplitGroupDetailScreenState
    extends ConsumerState<SplitGroupDetailScreen> {
  final _messageController = TextEditingController();
  final _activityScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Clear this user's unread badge for the group now that they're
    // viewing it. Doesn't affect the controller's `state`
    ref
        .read(splitBillControllerProvider.notifier)
        .markGroupRead(widget.groupId);
    _activityScrollController.addListener(_onActivityScroll);
  }

  void _onActivityScroll() {
    if (!_activityScrollController.hasClients) return;
    final pos = _activityScrollController.position;
    // reverse:true list -> scrolling toward maxScrollExtent means the
    // user is scrolling up toward older messages.
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(activityFeedProvider(widget.groupId).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _activityScrollController.removeListener(_onActivityScroll);
    _activityScrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await ref
        .read(splitBillControllerProvider.notifier)
        .sendMessage(groupId: widget.groupId, text: text);

    final error = ref.read(splitBillControllerProvider).error;
    if (error != null && mounted) {
      _messageController.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(splitBillControllerProvider, (previous, next) {
      if (next.hasError) {
        CommonSnackbar.showError(context, next.error!);
      }
    });
    final groupAsync = ref.watch(splitGroupProvider(widget.groupId));
    final currency =
        ref.watch(currencySettingProvider).value ?? AppCurrency.php;
    final currencyFormat = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
    );

    return groupAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Failed to load group: $err')),
      ),
      data: (group) {
        if (group == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Group not found')),
          );
        }
        return _buildScaffold(context, group, currencyFormat);
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    SplitGroup group,
    NumberFormat currencyFormat,
  ) {
    final billsAsync = ref.watch(splitBillsProvider(group.id));
    final activityAsync = ref.watch(activityFeedProvider(group.id));
    final loadingMore = ref.watch(activityLoadingMoreProvider(group.id));
    final membersAsync = ref.watch(groupMembersProvider(group.id));
    final currentUid = ref.watch(currentUserProvider)?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: SafeArea(
        child: billsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Failed to load bills: $err')),
          data: (bills) {
            final members = membersAsync.value ?? {};
            // Derived username-only map: keeps every existing `names[id]`
            // call site below unchanged.
            final names = {
              for (final e in members.entries) e.key: e.value.username,
            };

            return Column(
              children: [
                BalanceSummaryCard(
                  bills: bills,
                  currentUid: currentUid,
                  currency: currencyFormat,
                ),
                const SizedBox(height: 12),
                BillsCarousel(
                  bills: bills,
                  group: group,
                  currentUid: currentUid,
                  names: names,
                  currency: currencyFormat,
                ),
                Divider(
                  height: 24,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: activityAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('$err')),
                    data: (activity) => ActivityFeedView(
                      activity: activity,
                      currentUid: currentUid,
                      names: names,
                      members: members,
                      scrollController: _activityScrollController,
                      loadingMore: loadingMore,
                      currency: currencyFormat,
                    ),
                  ),
                ),
                MessageInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
