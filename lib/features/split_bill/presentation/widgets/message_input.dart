import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onPoke,
    required this.onAddPhoto,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPoke;
  final VoidCallback onAddPhoto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary),
            tooltip: 'Add photo',
            onPressed: onAddPhoto,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Message the group...',
                hintStyle: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.primary.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 4),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: Colors.transparent),
            icon: const Icon(Icons.back_hand_rounded, color: AppColors.primary),
            tooltip: 'Poke the group',
            onPressed: onPoke,
          ),
          const SizedBox(width: 4),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            tooltip: 'Send message',
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
