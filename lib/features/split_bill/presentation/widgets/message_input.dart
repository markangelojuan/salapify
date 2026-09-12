import 'package:flutter/material.dart';
import 'package:salapify/core/theme/app_colors.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key, required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
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
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}