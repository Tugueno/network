import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl = '',
    this.radius = 17,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.2),
      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
      child: avatarUrl.isEmpty
          ? Text(
              name.isNotEmpty ? name[0] : '?',
              style: TextStyle(
                fontSize: radius * 0.7,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}
