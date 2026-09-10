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

  List<Map<String, String>> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;
  bool _hasSearched = false;
  bool _isSaving = false;
  bool _isLoadingMembers = false;

  static const int _minSearchLength = 3;

  bool get _isEditing => widget.existingGroup != null;

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
      final results = await ref
          .read(userRepositoryProvider)
          .searchUsernames(trimmed);
      if (!mounted) return;

      final currentUid = ref.read(currentUserProvider)?.uid;
      setState(() {
        _suggestions = results
            .where((r) =>
                !_selectedMembers.containsKey(r['uid']) &&
                r['uid'] != currentUid) // exclude yourself from results
            .toList();
        _isSearching = false;
        _hasSearched = true;
      });
    });
  }

  void _addMember(Map<String, String> user) {
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
                hint: 'e.g. Roommates, Baguio Trip',
                label: 'Group name',
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter a group name'
                    : null,
              ),
              const SizedBox(height: 18),
              Text('Add members', style: TextStyle(color: AppColors.textPrimary)),
              const SizedBox(height: 8),
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
                    color: AppColors.primary.withValues(alpha: 0.05),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _suggestions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'No user found',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary.withValues(alpha: 0.5),
                              ),
                            ),
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
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.15),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                user['username']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
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
                      .map((e) => _MemberChip(
                            name: e.value,
                            onRemove: () => _removeMember(e.key),
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 28),
              CommonButton(
                label: _isEditing ? 'Save Changes' : 'Create Group',
                btnColor: AppColors.black,
                labelColor: AppColors.white,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          hintText: 'Search by username',
          hintStyle: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          suffixIcon: isSearching
              ? Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
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
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
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
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 15,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}