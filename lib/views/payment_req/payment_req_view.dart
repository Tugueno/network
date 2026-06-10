import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/payment_req_controller.dart';
import '../../models/payment_req_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/department_tag.dart';

class PaymentReqView extends GetView<PaymentReqController> {
  const PaymentReqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F0F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: AppTheme.textDark),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Төлбөрийн хүсэлт',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return const _EmptyState();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryCard(
              totalAmount: controller.formattedTotal,
              pendingCount: controller.pendingCount,
              approvedCount: controller.approvedCount,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Хүсэлтийн жагсаалт',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Material(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 4, thickness: 4, color: Color(0xFFF0F0F0),endIndent: 0,indent: 0,),
                  itemBuilder: (_, i) => _RequestRow(
                    item: controller.items[i],
                    onTap: () => controller.openDetail(controller.items[i]),
                  ),
                ),
              ),
            ),
          ),
          ],
        );
      }),
    );
  }
}

// ── Empty state ────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swap_horiz_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Танд төлбөрийн хүсэлт\nодоогоор байхгүй байна',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Төлбөрийн хүсэлт ирмэгц танд\nмэдэгдэх болно...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
          ),
        ],
      ),
    );
  }
}

// ── Summary card ───────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String totalAmount;
  final int pendingCount;
  final int approvedCount;

  const _SummaryCard({
    required this.totalAmount,
    required this.pendingCount,
    required this.approvedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Хүлээгдэж буй хүсэлтийн нийт дүн',
            style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 6),
          Text(
            totalAmount,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          _StatRow(
            icon: Icons.monetization_on,
            color: const Color(0xFFFF9500),
            label: 'Нийт хүлээгдэж буй',
            count: '$pendingCount хүсэлт',
          ),
          const SizedBox(height: 10),
          _StatRow(
            icon: Icons.check_circle,
            color: const Color(0xFF34C759),
            label: 'Зөвшөөрсөн',
            count: '$approvedCount хүсэлт',
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String count;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
          ),
        ),
        Text(
          count,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

// ── Request row ────────────────────────────────────────────
class _RequestRow extends StatelessWidget {
  final PaymentReqModel item;
  final VoidCallback onTap;
  const _RequestRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.id,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      DepartmentTag(label: item.department),
                      const SizedBox(width: 8),
                      Text(
                        item.assignee,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
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
                Text(
                  item.formattedAmount,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right,
                    size: 18, color: AppTheme.textGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
