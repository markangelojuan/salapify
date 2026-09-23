import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/core/theme/app_colors.dart';
import 'package:salapify/core/widgets/common_button.dart';
import 'package:salapify/core/widgets/common_snackbar.dart';
import 'package:salapify/core/widgets/common_text_field.dart';
import 'package:salapify/features/authentication/data/repositories/auth_repository.dart';
import 'package:salapify/features/authentication/data/repositories/user_repository.dart';
import 'package:salapify/features/split_bill/domain/entities/split_group.dart';
import 'package:salapify/features/split_bill/presentation/controllers/split_bill_controller.dart';
import 'package:salapify/features/split_bill/presentation/widgets/member_avatar.dart';
import 'package:salapify/features/split_bill/domain/entities/split_bill_limits.dart';

class GroupFormScreen extends ConsumerStatefulWidget {
  const GroupFormScreen({super.key, this.existingGroup});

  final SplitGroup? existingGroup;

  @override
  ConsumerState<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends ConsumerState<GroupFormScreen> {
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _selectedMembers = {};

  List<Map<String, String?>> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;
  bool _hasSearched = false;
  bool _isSaving = false;
  bool _isLoadingMembers = false;

  static const int _minSearchLength = 3;

  bool get _isEditing => widget.existingGroup != null;
  bool get _atMemberLimit =>
      _selectedMembers.length + 1 >= SplitBillLimits.maxGroupMembers;

  @override
  void initState() {
    super.initState();
    if (widget.existingGroup != null) {
      _nameController.text = widget.existingGroup!.name;
      _loadExistingMembers();
    }
  }

  Future<void> _loadExistingMembers() async {
    final group = widget.existingGroup!;
    setState(() => _isLoadingMembers = true);

    final userRepo = ref.read(userRepositoryProvider);
    final otherIds = group.memberIds.where((id) => id != group.createdBy);

    try {
      final entries = await Future.wait(
        otherIds.map((id) async {
          final username = await userRepo.getUsername(id);
          return MapEntry(id, username ?? 'Unknown');
        }),
      );

      if (!mounted) return;
      setState(() {
        _selectedMembers.addEntries(entries);
        _isLoadingMembers = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingMembers = false);
      CommonSnackbar.showError(context, e);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();

    if (trimmed.length < _minSearchLength) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
        _hasSearched = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _isSearching = true);
      try {
        final results = await ref
            .read(userRepositoryProvider)
            .searchUsernames(trimmed);
        if (!mounted) return;

        final currentUid = ref.read(currentUserProvider)?.uid;
        setState(() {
          _suggestions = results
              .where(
                (r) =>
                    !_selectedMembers.containsKey(r['uid']) &&
                    r['uid'] != currentUid,
              )
              .toList();
          _hasSearched = true;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _suggestions = []);
        CommonSnackbar.showError(context, e);
      } finally {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  void _addMember(Map<String, String?> user) {
    if (_atMemberLimit) return;
    setState(() {
      _selectedMembers[user['uid']!] = user['username']!;
      _suggestions = [];
      _hasSearched = false;
      _searchController.clear();
    });
  }

  void _removeMember(String uid) {
    setState(() => _selectedMembers.remove(uid));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final controller = ref.read(splitBillControllerProvider.notifier);

    if (_isEditing) {
      await controller.updateGroupDetails(
        groupId: widget.existingGroup!.id,
        name: _nameController.text.trim(),
        memberIds: {
          widget.existingGroup!.createdBy,
          ..._selectedMembers.keys,
        }.toList(),
      );
    } else {
      await controller.createGroup(
        name: _nameController.text.trim(),
        memberIds: _selectedMembers.keys.toList(),
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    final error = ref.read(splitBillControllerProvider).error;
    if (error != null) {
      CommonSnackbar.showError(context, error.toString());
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Group' : 'New Group')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CommonTextField(
                controller: _nameController,
                icon: Icons.groups_rounded,
                textInputAction: TextInputAction.done,
                maxCharacters: 55,
                hint: 'e.g. Roommates, Baguio Trip',
                label: 'Group name',
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter a group name'
                    : null,
              ),
              const SizedBox(height: 18),
              Text('Add members', style: TextStyle(color: colors.textPrimary)),
              const SizedBox(height: 8),
              if (_atMemberLimit)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Group is full (${SplitBillLimits.maxGroupMembers}/${SplitBillLimits.maxGroupMembers} members)',
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                )
              else
                _MemberSearchField(
                  controller: _searchController,
                  isSearching: _isSearching,
                  onChanged: _onSearchChanged,
                ),
              if (_hasSearched && !_isSearching)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  constraints: const BoxConstraints(maxHeight: 220),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.05),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.15),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _suggestions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 16,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No user found',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _suggestions.length,
                          itemBuilder: (context, i) {
                            final user = _suggestions[i];
                            return ListTile(
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              leading: MemberAvatar(
                                avatarId: user['avatarId'],
                                radius: 16,
                              ),
                              title: Text(
                                user['username']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: colors.textPrimary,
                                ),
                              ),
                              onTap: () => _addMember(user),
                            );
                          },
                        ),
                ),
              if (_isLoadingMembers)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (_selectedMembers.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedMembers.entries
                      .map(
                        (e) => _MemberChip(
                          name: e.value,
                          onRemove: () => _removeMember(e.key),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 28),
              CommonButton(
                label: _isEditing ? 'Save Changes' : 'Create Group',
                btnColor: colors.textPrimary,
                labelColor: colors.background,
                isLoading: _isSaving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Search field styled to match the app's primary-tinted input containers
/// (see ExpenseFormScreen/IncomeFormScreen date fields), rather than the
/// default Material TextField underline/fill.
class _MemberSearchField extends StatelessWidget {
  const _MemberSearchField({
    required this.controller,
    required this.isSearching,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isSearching;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: colors.textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          hintText: 'Search by username',
          hintStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: colors.primary,
          ),
          suffixIcon: isSearching
              ? Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Selected-member pill, matching the app's pill/chip language
/// (_TypeChip, category picker chips) instead of the default Material Chip.
class _MemberChip extends StatelessWidget {
  const _MemberChip({required this.name, required this.onRemove});

  final String name;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExt>()!;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 15,
              color: colors.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
