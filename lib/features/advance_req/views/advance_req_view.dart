import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';

class AdvanceReqView extends GetView<AdvanceReqController> {
  const AdvanceReqView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Урдчилгаа хаах',
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Та төлбөрийн хүсэлт\nүүсгээгүй байна.',
            subtitle: 'NetBase-руугаа орж\nтөлбөрийн хүсэлтээ үүсгэнэ үү.',
          );
        }
        return _buildList();
      }),
    );
  }

  Widget _buildList() {
    final pending = controller.pending;
    final closed = controller.closed;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (pending.isNotEmpty) ...[
          _SectionHeader(
            label: 'Үлдэгдэлтэй нийт ${pending.length}',
          ),
          const SizedBox(height: 8),
          _ItemGroup(items: pending),
          const SizedBox(height: 20),
        ],
        if (closed.isNotEmpty) ...[
          _SectionHeader(
            label: 'Хаасан нийт ${closed.length}',
          ),
          const SizedBox(height: 8),
          _ItemGroup(items: closed),
        ],
      ],
    );
  }
}

// ── Section header ─────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textGrey,
      ),
    );
  }
}

// ── Group of tiles in a white card ────────────────────────
class _ItemGroup extends StatelessWidget {
  final List<AdvanceReqModel> items;
  const _ItemGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      clip: true,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppTheme.textGrey.withValues(alpha: 0.15),
              ),
            _AdvanceTile(item: items[i]),
          ],
        ],
      ),
    );
  }
}

// ── Individual tile ────────────────────────────────────────
class _AdvanceTile extends StatelessWidget {
  final AdvanceReqModel item;
  const _AdvanceTile({required this.item});

  bool get _isPending => item.status == AdvanceReqStatus.pending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.find<AdvanceReqController>().openDetail(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Status icon
            _StatusIcon(isPending: _isPending),
            const SizedBox(width: 12),

            // ID + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Amounts + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatTugrik(item.usedAmount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '/${formatTugrik(item.totalAmount)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 24, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}

// ── Status icon ────────────────────────────────────────────
class _StatusIcon extends StatelessWidget {
  final bool isPending;
  const _StatusIcon({required this.isPending});

  @override
  Widget build(BuildContext context) {
    if (isPending) {
      return Container(
        width: 25,
        height: 25,
        decoration: const BoxDecoration(
          color: Color(0xFFFF9500),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.access_time, size: 25, color: Colors.white),
      );
    }
    return const Icon(
      Icons.check_circle,
      size: 25,
      color: Color(0xFF34C759),
    );
  }
}
