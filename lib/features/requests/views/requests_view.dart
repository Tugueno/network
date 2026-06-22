import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/widgets/employee_filter_chips.dart';
import 'package:ncapp/features/requests/widgets/request_card.dart';
import 'package:ncapp/features/requests/widgets/request_toast.dart';
import 'package:ncapp/features/requests/widgets/requests_bottom_actions.dart';
import 'package:ncapp/features/requests/widgets/requests_date_header.dart';
import 'package:ncapp/features/requests/widgets/requests_tab_bar.dart';
import 'package:ncapp/widgets/app_scaffold.dart';

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
            if (controller.allRequests.isEmpty) {
              return const EmptyState(
                icon: Icons.send_outlined,
                title: 'Одоогоор ирцийн хүсэлт\nирээгүй байна...',
              );
            }

            return Column(
              children: [
                RequestsTabBar(controller: controller),
                Obx(() {
                  final applied = controller.appliedEmployees;
                  if (applied.isEmpty) return const SizedBox.shrink();

                  return EmployeeFilterChips(
                    employees: applied,
                    onRemove: controller.removeAppliedEmployee,
                  );
                }),
                RequestsDateHeader(controller: controller),
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
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => RequestCard(
                        item: list[i],
                        onTap: () => controller.toggleSelect(list[i].id),
                      ),
                    );
                  }),
                ),
              ],
            );
          }),
          Obx(() {
            if (!controller.toastVisible.value) return const SizedBox.shrink();

            return Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: RequestToast(message: controller.toastMessage.value),
            );
          }),
        ],
      ),
      bottomSheet: Obx(() {
        if (controller.selectedCount == 0) return const SizedBox.shrink();
        return RequestsBottomActions(controller: controller);
      }),
    );
  }
}
