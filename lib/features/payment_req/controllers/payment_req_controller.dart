import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/data/payment_req_repository.dart';
import 'package:ncapp/theme/app_theme.dart';

enum PeriodFilterType { month, quarter, range }

class PaymentReqController extends GetxController {
  late final PaymentReqRepository _repo;

  // ── State ─────────────────────────────────────────────────
  final items = <PaymentReqModel>[].obs;
  final isLoading = true.obs;
  final selectedItem = Rxn<PaymentReqModel>();
  final selectedFilter = PaymentReqStatus.pending.obs;

  // period filter (month / quarter / date range)
  final periodType = PeriodFilterType.month.obs;
  final selectedMonth = DateTime.now().month.obs;
  final selectedQuarter = ((DateTime.now().month - 1) ~/ 3 + 1).obs;
  final rangeStart = Rxn<DateTime>();
  final rangeEnd = Rxn<DateTime>();
  final periodSheetOpen = false.obs;

  // ── Computed ──────────────────────────────────────────────
  List<PaymentReqModel> get periodItems {
    switch (periodType.value) {
      case PeriodFilterType.month:
        return items.where((r) => r.month == selectedMonth.value).toList();
      case PeriodFilterType.quarter:
        final first = (selectedQuarter.value - 1) * 3 + 1;
        return items
            .where((r) => r.month >= first && r.month <= first + 2)
            .toList();
      case PeriodFilterType.range:
        final start = rangeStart.value;
        final end = rangeEnd.value;
        if (start == null || end == null) return items.toList();
        return items.where((r) {
          final d = r.dateTime;
          return d != null && !d.isBefore(start) && !d.isAfter(end);
        }).toList();
    }
  }

  List<PaymentReqModel> get filtered =>
      periodItems.where((r) => r.status == selectedFilter.value).toList();

  int countFor(PaymentReqStatus status) =>
      periodItems.where((r) => r.status == status).length;

  String get formattedFilteredTotal =>
      formatTugrik(filtered.fold(0, (s, r) => s + r.amount));

  String get totalLabel {
    switch (selectedFilter.value) {
      case PaymentReqStatus.pending:
        return 'Хүлээгдэж буй нийт дүн:';
      case PaymentReqStatus.approved:
        return 'Зөвшөөрсөн нийт дүн:';
      case PaymentReqStatus.rejected:
        return 'Буцаасан нийт дүн:';
    }
  }

  String get periodLabel {
    switch (periodType.value) {
      case PeriodFilterType.month:
        return '${selectedMonth.value}-р сар';
      case PeriodFilterType.quarter:
        return '${selectedQuarter.value}-р улирал';
      case PeriodFilterType.range:
        final s = rangeStart.value;
        final e = rangeEnd.value;
        if (s == null || e == null) return 'Огноо';
        return '${formatRangeDate(s)} - ${formatRangeDate(e)}';
    }
  }

  String get sectionTitle {
    switch (periodType.value) {
      case PeriodFilterType.month:
        return '${selectedMonth.value}-р сарын хүсэлтийн жагсаалт';
      case PeriodFilterType.quarter:
        return '${selectedQuarter.value}-р улирлын хүсэлтийн жагсаалт';
      case PeriodFilterType.range:
        return 'Сонгосон хугацааны хүсэлтийн жагсаалт';
    }
  }

  static String formatRangeDate(DateTime d) =>
      '${d.month} сарын ${d.day.toString().padLeft(2, '0')}';

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<PaymentReqRepository>();
    fetchRequests();
  }

  // ── Actions ───────────────────────────────────────────────
  Future<void> fetchRequests() async {
    isLoading.value = true;
    try {
      items.assignAll(await _repo.fetchRequests());
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(PaymentReqStatus status) => selectedFilter.value = status;

  void applyPeriod({
    required PeriodFilterType type,
    int? month,
    int? quarter,
    DateTime? start,
    DateTime? end,
  }) {
    periodType.value = type;
    if (month != null) selectedMonth.value = month;
    if (quarter != null) selectedQuarter.value = quarter;
    rangeStart.value = start;
    rangeEnd.value = end;
  }

  void openDetail(PaymentReqModel item) {
    selectedItem.value = item;
    if (Get.width < 720) Get.toNamed(AppRoutes.paymentreqDetail);
  }

  void closeDetail({bool popRoute = false}) {
    selectedItem.value = null;
    if (popRoute && Get.currentRoute == AppRoutes.paymentreqDetail) {
      Get.back();
    }
  }

  Future<void> approve(PaymentReqModel item) async {
    await _repo.approve(item.id);
    _setStatus(item, PaymentReqStatus.approved);
    _closeToList();
    _showResultToast('Төлбөрийн хүсэлт батлагдлаа.');
  }

  Future<void> reject(PaymentReqModel item) async {
    await _repo.reject(item.id);
    _setStatus(item, PaymentReqStatus.rejected);
    _closeToList();
    _showResultToast('Төлбөрийн хүсэлт буцаагдлаа.');
  }

  // optimistic update — replace with real API response
  void _setStatus(PaymentReqModel item, PaymentReqStatus status) {
    final index = items.indexOf(item);
    if (index == -1) return;
    final updated = item.copyWith(status: status, decisionDate: _today());
    items[index] = updated;
    selectedItem.value = updated;
  }

  String _today() {
    final n = DateTime.now();
    return '${n.month.toString().padLeft(2, '0')}/'
        '${n.day.toString().padLeft(2, '0')}/${n.year}';
  }

  void _closeToList() {
    selectedItem.value = null;
    if (Get.width < 720) Get.back();
  }

  void _showResultToast(String message) {
    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(top: 8),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      messageText: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 20,
                color: Color(0xFF34C759),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
