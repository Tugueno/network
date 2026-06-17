import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';
import 'filter_overlay_view.dart';

class RequestsView extends GetView<RequestsController> {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Ирцийн хүсэлтүүд',
      backgroundColor: const Color(0xFFF5F5F5),
      appBarColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(() {
            // Дата огт байхгүй бол — шүүх хэсгийг нууж, зөвхөн empty state
            if (controller.allRequests.isEmpty) {
              return const EmptyState(
                icon: Icons.send_outlined,
                title: 'Одоогоор ирцийн хүсэлт\nирээгүй байна...',
              );
            }
            return Column(
              children: [
                // ── Tab bar ──────────────────────────────
                _TabBar(controller: controller),

                // ── Applied employee filter chips ─────────
                Obx(() {
                  final applied = controller.appliedEmployees;
                  if (applied.isEmpty) return const SizedBox.shrink();
                  return _EmployeeFilterChips(
                    employees: applied,
                    onRemove: controller.removeAppliedEmployee,
                  );
                }),

                // ── Date + filter icon ────────────────────
                _DateHeader(controller: controller),

                // ── List ──────────────────────────────────
                Expanded(
                  child: Obx(() {
                    final list = controller.filtered;
                    if (list.isEmpty) {
                      return const EmptyState(
                        icon: Icons.send_outlined,
                        title: 'Одоогоор ирцийн хүсэлт\nирээгүй байна...',
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _RequestCard(
                        item: list[i],
                        onTap: () => controller.toggleSelect(list[i].id),
                      ),
                    );
                  }),
                ),
              ],
            );
          }),

          // ── Toast overlay ──────────────────────────────
          Obx(() {
            if (!controller.toastVisible.value) return const SizedBox.shrink();
            return Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _Toast(message: controller.toastMessage.value),
            );
          }),
        ],
      ),

      // ── Bottom action bar (shown when items are selected) ──
      bottomSheet: Obx(() {
        if (controller.selectedCount == 0) return const SizedBox.shrink();
        return _BottomActions(controller: controller);
      }),
    );
  }
}

// ── Tab bar ────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final RequestsController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Obx(
        () => Row(
          children: [
            _TabChip(
              label: 'Ирсэн',
              count: controller.countOf(RequestStatus.irsen),
              selected: controller.selectedTab.value == 0,
              onTap: () => controller.selectedTab.value = 0,
            ),
            const SizedBox(width: 8),
            _TabChip(
              label: 'Зөвшөөрсөн',
              count: controller.countOf(RequestStatus.zuvshuursun),
              selected: controller.selectedTab.value == 1,
              onTap: () => controller.selectedTab.value = 1,
            ),
            const SizedBox(width: 8),
            _TabChip(
              label: 'Цуцалсан',
              count: controller.countOf(RequestStatus.tsutsalsan),
              selected: controller.selectedTab.value == 2,
              onTap: () => controller.selectedTab.value = 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.borderColor,
          ),
        ),
        child: Text(
          '$label $count',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppTheme.textGrey,
          ),
        ),
      ),
    );
  }
}

// ── Applied employee chips row ─────────────────────────────
class _EmployeeFilterChips extends StatelessWidget {
  final List<EmployeeModel> employees;
  final void Function(String id) onRemove;
  const _EmployeeFilterChips({required this.employees, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: employees
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onRemove(e.id),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ── Date header with filter icon ───────────────────────────
class _DateHeader extends StatelessWidget {
  final RequestsController controller;
  const _DateHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              controller.months[controller.appliedMonthIndex.value],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.initFilterFromApplied();
              Get.bottomSheet(
                const FilterOverlayView(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: const Icon(Icons.tune, size: 20, color: AppTheme.textGrey),
          ),
        ],
      ),
    );
  }
}

// ── Request card ───────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final RequestModel item;
  final VoidCallback onTap;
  const _RequestCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.isSelected.value
                  ? AppTheme.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Type + hours ─────────────────────────
              Row(
                children: [
                  Icon(
                    item.isSelected.value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: item.isSelected.value
                        ? AppTheme.primary
                        : AppTheme.textGrey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.type.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  Text(
                    '${item.totalHours} цаг',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // ── Time range ───────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  item.timeRange,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // ── Date range ───────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  item.dateRange,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Reason ───────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${item.reason}"',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textDark,
                  ),
                ),
              ),

              // ── File attachment ──────────────────────
              if (item.fileUrl != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.attach_file, size: 16, color: AppTheme.primary),
                    SizedBox(width: 4),
                    Text(
                      'Файл татах',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 8),

              // ── Sender + timestamp ───────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppTheme.primaryLight.withValues(
                      alpha: 0.2,
                    ),
                    backgroundImage: item.senderAvatar.isNotEmpty
                        ? NetworkImage(item.senderAvatar)
                        : null,
                    child: item.senderAvatar.isEmpty
                        ? Text(
                            item.senderName[0],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.senderName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${item.sentAt.year}/'
                    '${item.sentAt.month.toString().padLeft(2, '0')}/'
                    '${item.sentAt.day.toString().padLeft(2, '0')} '
                    '${item.sentAt.hour.toString().padLeft(2, '0')}:'
                    '${item.sentAt.minute.toString().padLeft(2, '0')}мин',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom action buttons ──────────────────────────────────
class _BottomActions extends StatelessWidget {
  final RequestsController controller;
  const _BottomActions({required this.controller});

  void _showConfirm(BuildContext context, {required bool isApprove}) {
    Get.bottomSheet(
      _ConfirmSheet(controller: controller, isApprove: isApprove),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final isIrsen = controller.selectedTab.value == 0;
        final count = controller.selectedCount;

        if (isIrsen) {
          // Ирсэн tab: Цуцлах + Батлах(N)
          return Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => _showConfirm(context, isApprove: false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      foregroundColor: AppTheme.error,
                    ),
                    child: const Text(
                      'Цуцлах',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _showConfirm(context, isApprove: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Батлах ($count)',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Зөвшөөрсөн / Цуцалсан tab: Цуцлах only
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _showConfirm(context, isApprove: false),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              foregroundColor: AppTheme.error,
            ),
            child: const Text(
              'Цуцлах',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }),
    );
  }
}

// ── Confirmation bottom sheet ──────────────────────────────
class _ConfirmSheet extends StatelessWidget {
  final RequestsController controller;
  final bool isApprove;
  const _ConfirmSheet({required this.controller, required this.isApprove});

  @override
  Widget build(BuildContext context) {
    final items = controller.selectedItems;
    final count = items.length;
    final isApproved = controller.selectedTab.value == 1;

    final title = isApprove
        ? '$count ирцийн хүсэлт батлах'
        : isApproved
        ? '$count зөвшөөрсөн ирцийн хүсэлт цуцлах'
        : '$count ирцийн хүсэлт цуцлах';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grabber
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),

            // Selected items list
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                itemBuilder: (_, i) => _ConfirmItem(item: items[i]),
              ),
            ),
            const SizedBox(height: 16),

            // Action button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isApprove
                  ? ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.approve();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Батлах',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        Get.back();
                        controller.reject();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        foregroundColor: AppTheme.error,
                      ),
                      child: const Text(
                        'Цуцлах',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ConfirmItem extends StatelessWidget {
  final RequestModel item;
  const _ConfirmItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.type.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timeRange,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${item.totalHours} цаг',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.dateRange,
            style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"${item.reason}"',
              style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.2),
                child: Text(
                  item.senderName[0],
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item.senderName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark,
                ),
              ),
              const Spacer(),
              Text(
                '${item.sentAt.year}/${item.sentAt.month.toString().padLeft(2, '0')}/'
                '${item.sentAt.day.toString().padLeft(2, '0')} '
                '${item.sentAt.hour.toString().padLeft(2, '0')}:'
                '${item.sentAt.minute.toString().padLeft(2, '0')}мин',
                style: const TextStyle(fontSize: 11, color: AppTheme.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Toast notification ─────────────────────────────────────
class _Toast extends StatelessWidget {
  final String message;
  const _Toast({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
