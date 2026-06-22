import 'package:flutter/material.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/theme/app_text_styles.dart';
import 'package:ncapp/theme/app_theme.dart';

class AdvanceReqPartialSection extends StatelessWidget {
  final bool isPartial;
  final ValueChanged<bool> onToggle;
  final TextEditingController partialCtrl;
  final TextEditingController haakhDunCtrl;

  const AdvanceReqPartialSection({
    required this.isPartial,
    required this.onToggle,
    required this.partialCtrl,
    required this.haakhDunCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Хэсэгчилж оруулах',
              style: TextStyle(fontSize: 14, color: AppTheme.textDark),
            ),
            const Spacer(),
            Switch(
              value: isPartial,
              onChanged: onToggle,
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withValues(alpha: 0.4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        if (isPartial) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '₮',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: partialCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textDark,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Хэсэгчилсэн дүн оруулах',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: Listenable.merge([partialCtrl, haakhDunCtrl]),
                  builder: (_, _) {
                    final partial =
                        int.tryParse(
                          partialCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        ) ??
                        0;
                    final haakh =
                        int.tryParse(
                          haakhDunCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                        ) ??
                        0;
                    final newAmt = (haakh - partial).clamp(0, haakh);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                      child: Text(
                        'Шинэ хаах дүн: ${formatTugrik(newAmt)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ] else
          const SizedBox(height: 4),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Comment box — Тайлбар text area
// ════════════════════════════════════════════════════════════

class AdvanceReqCommentBox extends StatelessWidget {
  final TextEditingController controller;
  const AdvanceReqCommentBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: 5,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: 'Тайлбар оруулах',
        hintStyle: AppTextStyles.hint,
        filled: true,
        fillColor: const Color(0xFFF5F6FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Label + inline editable field (Хаах дүн / ДДТД)
// ════════════════════════════════════════════════════════════

class AdvanceReqLabelField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;

  const AdvanceReqLabelField({
    required this.label,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: AppTheme.textGrey,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

