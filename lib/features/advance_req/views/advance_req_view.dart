import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/responsive/app_breakpoints.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';
import 'advance_req_detail_view.dart';

class AdvanceReqView extends GetView<AdvanceReqController> {
  const AdvanceReqView({super.key});

  @override
  Widget build(BuildContext context) {
    final openDetailInRoute = AppBreakpoints.shouldOpenDetailInRoute(
      MediaQuery.sizeOf(context).width,
    );

    return AppScaffold(
      title: 'Урдчилгаа хаах',
      backgroundColor: AppTheme.screenBackground,
      appBarColor: AppTheme.screenBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = AppBreakpoints.supportsSplitPane(constraints.maxWidth);
          return Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final error = controller.errorMessage.value;
            if (error != null && controller.items.isEmpty) {
              return EmptyState(
                icon: Icons.cancel_rounded,
                iconColor: Colors.red,
                title: error,
                subtitle: 'Интернэт холболтоо шалгаад дахин оролдоно уу.',
                actionLabel: 'Дахин оролдох',
                onAction: controller.refresh,
              );
            }

            if (controller.items.isEmpty) {
              return const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Та төлбөрийн хүсэлт\nүүсгээгүй байна.',
                subtitle: 'NetBase-руугаа орж\nтөлбөрийн хүсэлтээ үүсгэнэ үү.',
              );
            }

            final listCol = _buildList(openDetailInRoute: openDetailInRoute);

            if (!isWide) return listCol;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppBreakpoints.shellListPaneWidth,
                  child: listCol,
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppTheme.borderColor,
                ),
                Expanded(
                  child: controller.selectedItem.value == null
                      ? const Center(
                          child: Text(
                            'Хүсэлт сонгоно уу',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                          ),
                        )
                      : const AdvanceReqDetailView(),
                ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildList({required bool openDetailInRoute}) {
    final pending = controller.pending;
    final closed = controller.closed;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          if (pending.isNotEmpty) ...[
            _SectionHeader(label: 'Үлдэгдэлтэй нийт ${pending.length}'),
            const SizedBox(height: 8),
            _ItemGroup(items: pending, openDetailInRoute: openDetailInRoute),
            const SizedBox(height: 20),
          ],
          if (closed.isNotEmpty) ...[
            _SectionHeader(label: 'Хаасан нийт ${closed.length}'),
            const SizedBox(height: 8),
            _ItemGroup(items: closed, openDetailInRoute: openDetailInRoute),
          ],
        ],
      ),
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
  final bool openDetailInRoute;

  const _ItemGroup({required this.items, required this.openDetailInRoute});

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
            _AdvanceTile(item: items[i], openDetailInRoute: openDetailInRoute),
          ],
        ],
      ),
    );
  }
}

// ── Individual tile ────────────────────────────────────────
class _AdvanceTile extends StatelessWidget {
  final AdvanceReqModel item;
  final bool openDetailInRoute;

  const _AdvanceTile({required this.item, required this.openDetailInRoute});

  bool get _isPending => item.status == AdvanceReqStatus.pending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.find<AdvanceReqController>().openDetail(
        item,
        openInRoute: openDetailInRoute,
      ),
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
    return const Icon(Icons.check_circle, size: 25, color: Color(0xFF34C759));
  }
}
