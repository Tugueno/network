import 'package:flutter/material.dart';
import 'package:ncapp/core/utils/attachment_file_opener.dart';
import 'package:ncapp/core/widgets/bottom_sheet_container.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/user_avatar.dart';

class PaymentReqAttachmentSheet extends StatelessWidget {
  final List<AttachmentGroup> groups;
  const PaymentReqAttachmentSheet({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return BottomSheetContainer(
      maxHeightFactor: 0.85,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Хавсаргасан файлууд',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: appColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Хавсаргасан файл байхгүй',
              style: TextStyle(fontSize: 14, color: appColors.textSecondary),
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: groups.length,
              separatorBuilder: (_, _) => const SizedBox(height: 20),
              itemBuilder: (_, i) => _GroupSection(group: groups[i]),
            ),
          ),
      ],
    );
  }
}

class _GroupSection extends StatelessWidget {
  final AttachmentGroup group;
  const _GroupSection({required this.group});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserAvatar(
              name: group.personName,
              avatarUrl: group.avatarUrl,
              radius: 17,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        group.personName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appColors.textPrimary,
                        ),
                      ),
                      if (group.personRole.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            group.personRole,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: appColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    group.date,
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: group.files.length,
          itemBuilder: (_, i) => _FileTile(file: group.files[i]),
        ),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  final AttachmentFile file;
  const _FileTile({required this.file});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return InkWell(
      onTap: () => AttachmentFileOpener.open(context, file),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: file.url.isNotEmpty
                  ? Image.network(
                      file.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, _, _) => _placeholder(appColors),
                    )
                  : _placeholder(appColors),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            file.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: appColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(AppThemeColors appColors) => Container(
    color: appColors.subtleFill,
    child: Center(
      child: Icon(
        Icons.insert_drive_file_outlined,
        size: 28,
        color: appColors.textSecondary,
      ),
    ),
  );
}
