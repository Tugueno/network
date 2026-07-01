import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/responsive/app_breakpoints.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/core/widgets/app_text.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_status_ui.dart';
import 'package:ncapp/core/widgets/app_chip.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';
import 'package:ncapp/widgets/department_tag.dart';
import 'payment_req_period_sheet.dart';
import 'payment_req_detail_view.dart';
import 'package:ncapp/core/widgets/app_card.dart';

class PaymentReqView extends GetView<PaymentReqController> {
  const PaymentReqView({super.key});

  @override
  Widget build(BuildContext context) {
    final openDetailInRoute = AppBreakpoints.shouldOpenDetailInRoute(
      MediaQuery.sizeOf(context).width,
    );
    const pageColor = AppTheme.screenBackground;

    return AppScaffold(
      title: 'Төлбөрийн хүсэлт',
      backgroundColor: pageColor,
      appBarColor: pageColor,
      statusBarColor: pageColor,
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
                onAction: controller.fetchRequests,
              );
            }

            if (controller.items.isEmpty) {
              return const EmptyState(
                icon: Icons.swap_horiz_rounded,
                title: 'Танд төлбөрийн хүсэлт\nодоогоор байхгүй байна',
                subtitle: 'Төлбөрийн хүсэлт ирмэгц танд\nмэдэгдэх болно...',
              );
            }
            final filtered = controller.filtered;
            final listCol = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterHeader(
                  sheetOpen: controller.periodSheetOpen.value,
                  onMonthTap: () => _showPeriodSheet(context),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchRequests,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      children: [
                        _TotalCard(
                          status: controller.selectedFilter.value,
                          label: controller.totalLabel,
                          total: controller.formattedFilteredTotal,
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(controller.sectionTitle),
                        const SizedBox(height: 12),
                        _RequestList(
                          items: filtered,
                          onTap: (item) => controller.openDetail(
                            item,
                            openInRoute: openDetailInRoute,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

            if (!isWide) return listCol;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppBreakpoints.paymentListPaneWidth,
                  child: listCol,
                ),
                Expanded(
                  child: controller.selectedItem.value == null
                      ? const Center(
                          child: AppText.bodyGrey('Нэг хүсэлт сонгоно уу!'),
                        )
                      : const PaymentReqDetailView(),
                ),
              ],
            );
          });
        },
      ),
    );
  }

  Future<void> _showPeriodSheet(BuildContext context) async {
    controller.periodSheetOpen.value = true;
    await showAdaptiveModal(
      context: context,
      maxWidth: 560,
      builder: (_) => const PaymentReqPeriodSheet(),
    );
    controller.periodSheetOpen.value = false;
  }
}

// ── Filter header (period row + status chips, pinned) ─────
class _FilterHeader extends GetView<PaymentReqController> {
  final bool sheetOpen;
  final VoidCallback onMonthTap;
  const _FilterHeader({required this.sheetOpen, required this.onMonthTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      clip: true,
      child: Column(
        children: [
          GestureDetector(
            onTap: onMonthTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const AppText.bodyBold('Хугацаа'),
                  const Spacer(),
                  AppText.body(controller.periodLabel),
                  const SizedBox(width: 4),
                  Icon(
                    sheetOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppTheme.textGrey,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                AppChip(
                  label: 'Хүлээгдэж буй',
                  count: controller.countFor(PaymentReqStatus.pending),
                  selected:
                      controller.selectedFilter.value ==
                      PaymentReqStatus.pending,
                  onTap: () =>
                      controller.selectFilter(PaymentReqStatus.pending),
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: 'Зөвшөөрсөн',
                  count: controller.countFor(PaymentReqStatus.approved),
                  selected:
                      controller.selectedFilter.value ==
                      PaymentReqStatus.approved,
                  onTap: () =>
                      controller.selectFilter(PaymentReqStatus.approved),
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: 'Буцаасан',
                  count: controller.countFor(PaymentReqStatus.rejected),
                  selected:
                      controller.selectedFilter.value ==
                      PaymentReqStatus.rejected,
                  onTap: () =>
                      controller.selectFilter(PaymentReqStatus.rejected),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Total card ─────────────────────────────────────────────
class _TotalCard extends StatelessWidget {
  final PaymentReqStatus status;
  final String label;
  final String total;

  const _TotalCard({
    required this.status,
    required this.label,
    required this.total,
  });

  // Нийт картын онцлох өнгө — pending=улбар шар (status.color-оос ялгаатай).
  Color get _iconColor {
    switch (status) {
      case PaymentReqStatus.pending:
        return const Color(0xFFFF9500);
      case PaymentReqStatus.approved:
        return const Color(0xFF34C759);
      case PaymentReqStatus.rejected:
        return const Color(0xFFFF3B30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      radius: 12,
      child: Row(
        children: [
          Icon(status.icon, size: 20, color: _iconColor),
          const SizedBox(width: 8),
          Expanded(child: AppText.bodyBold(label, color: AppTheme.textGrey)),
          AppText.amount(total),
        ],
      ),
    );
  }
}

// ── Section title (e.g. "Хүлээгдэж буй хүсэлтүүд") ──────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => AppText.heading(text);
}

// ── Request list (white card, divider-separated cards) ──────
class _RequestList extends StatelessWidget {
  final List<PaymentReqModel> items;
  final ValueChanged<PaymentReqModel> onTap;
  const _RequestList({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: AppText.bodyGrey('Энэ ангилалд хүсэлт байхгүй байна'),
        ),
      );
    }

    return AppCard(
      // extra space under the last tile, per design
      padding: const EdgeInsets.only(bottom: 12),
      clip: true,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 2,
                thickness: 2,
                color: AppTheme.textGrey.withValues(alpha: 0.25),
              ),
            _RequestCard(item: items[i], onTap: () => onTap(items[i])),
          ],
        ],
      ),
    );
  }
}

// ── Request card ───────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final PaymentReqModel item;
  final VoidCallback onTap;
  const _RequestCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPending = item.status == PaymentReqStatus.pending;
    final showDecision = !isPending && item.decisionDate.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppText.bodyHeavy(item.id),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppText.bodyBoldGrey(
                              item.date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          DepartmentTag(label: item.department),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppText.bodyBoldGrey(
                              item.assignee,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.bodyBold(item.formattedAmount),
                    if (isPending) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppTheme.textGrey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (showDecision) ...[
              const SizedBox(height: 10),
              const SizedBox(height: 8),
              Row(
                children: [
                  AppText.caption(item.status.decisionLabel),
                  const Spacer(),
                  AppText.captionBold(item.decisionDate),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
