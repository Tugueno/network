import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isLoading;

  const ActionButtons({
    super.key,
    required this.onReject,
    required this.onApprove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              16, 12, 16, MediaQuery.of(context).padding.bottom + 24),
          color: Colors.white.withOpacity(0.1),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEEEE),
                      side: const BorderSide(color: AppTheme.error),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      foregroundColor: AppTheme.error,
                    ),
                    child: const Text(
                      'Цуцлах',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Батлах',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

