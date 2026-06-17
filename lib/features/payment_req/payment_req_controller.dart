import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/features/payment_req/payment_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';

enum PeriodFilterType { month, quarter, range }

class PaymentReqController extends GetxController {
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
    fetchRequests();
  }

  // ── Actions ───────────────────────────────────────────────
  Future<void> fetchRequests() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // TODO: replace with API call
    items.value = _mockData;
    isLoading.value = false;
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
    Get.toNamed(AppRoutes.paymentreqDetail);
  }

  Future<void> approve(PaymentReqModel item) async {
    // TODO: call API
    _setStatus(item, PaymentReqStatus.approved);
    _closeToList();
    _showResultToast('Төлбөрийн хүсэлт батлагдлаа.');
  }

  Future<void> reject(PaymentReqModel item) async {
    // TODO: call API
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
    Get.until((route) => route.settings.name == AppRoutes.paymentreq);
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
              const Icon(Icons.check_circle,
                  size: 20, color: Color(0xFF34C759)),
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

// ── Mock data (replace with real API) ─────────────────────
final _mockData = [
  PaymentReqModel(
    id: 'FPR01866',
    department: 'PUR',
    date: '06/22/2026',
    amount: 5000000,
    assignee: 'А. Жавхлан',
    assigneeRole: 'Дижитал бутээгдэхүүний удирлага, инновац...',
    assigneeLore: 'Газрын захирал',
    paymentDate: '06/22/2026',
    company: 'Нэткaпитал Финанс Корпораци...',
    description:
        'Удирлагын зөвлөлийн ээлжит уулзалтын зохион байгуулат болон логистикийн зардал (хоол унд, хэвлэл ба сургалтын материал).',
    attachmentCount: 5,
    attachmentGroups: const [
      AttachmentGroup(
        personName: 'Д. Баяржаргал',
        personRole: 'Хүсэгч',
        date: '05/20/2026',
        files: [
          AttachmentFile(name: 'Document Pay..'),
          AttachmentFile(name: 'Document Pay..'),
          AttachmentFile(name: 'Document Pay..'),
        ],
      ),
      AttachmentGroup(
        personName: 'Б. Алдар',
        personRole: '',
        date: '05/20/2026',
        files: [
          AttachmentFile(name: 'Document Pay..'),
          AttachmentFile(name: 'Document Pay..'),
        ],
      ),
    ],
    status: PaymentReqStatus.pending,
    requestDetails: const [
      DetailItem(subtitle: 'Хүсэлтийн дугаар', info: 'FPR01866'),
      DetailItem(subtitle: 'Хүсэлтийн огноо', info: '06/22/2026'),
      DetailItem(subtitle: 'Хэлтэс', info: 'PUR'),
      DetailItem(subtitle: 'Хариуцагч', info: 'А. Жавхлан'),
      DetailItem(subtitle: 'Компани', info: 'Нэткапитал Финанс'),
      DetailItem(subtitle: 'Статус', info: 'Хүлээгдэж буй'),
    ],
    budgetDetails: const [
      DetailItem(subtitle: 'Нийт төсөвлөсөн', info: "5'000'000₮"),
      DetailItem(subtitle: 'Хоол унд', info: "1'500'000₮"),
      DetailItem(subtitle: 'Хэвлэл материал', info: "800'000₮"),
      DetailItem(subtitle: 'Сургалтын материал', info: "700'000₮"),
      DetailItem(subtitle: 'Логистик', info: "2'000'000₮"),
    ],
    approvalSteps: [
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'Д. Баяржаргал',
        comment: 'Баталсан',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
      ),
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'А. Жавхлан',
        comment: 'Худалдан авалтын хянал хийгдсэн. Үнийн харьцуулалт болон баримтууд шаардлага хангаж байна.',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
        isReturned: true,
      ),
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'С. Болд',
        comment: 'Баталсан',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
      ),
      ApprovalStepModel(
        label: 'СТУНИШГ Хянасан',
        person: 'М. Энхбаяр',
        comment: 'Баталсан',
        date: '06/22 12:20',
        status: ApprovalStepStatus.done,
      ),
      ApprovalStepModel(
        label: 'Зөвшөөрсөн',
        person: 'Б. Баянбат',
        comment: null,
        date: '',
        status: ApprovalStepStatus.pending,
      ),
    ],
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'NPL',
    date: '06/22/2026',
    amount: 16000000,
    assignee: 'Д. Эрдэм-Од',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'PUR',
    date: '06/22/2026',
    amount: 4000000,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.approved,
    decisionDate: '06/23/2026',
  ),
  PaymentReqModel(
    id: 'FPR01867',
    department: 'PUR',
    date: '06/22/2026',
    amount: 740100,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 1,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01868',
    department: 'FAD',
    date: '06/22/2026',
    amount: 1500000,
    assignee: 'М. Баасанжаргал',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 2,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01869',
    department: 'NPL',
    date: '06/23/2026',
    amount: 3200000,
    assignee: 'Б. Баянбат',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'FAD',
    date: '06/22/2026',
    amount: 1010200,
    assignee: 'М. Баасанжаргал',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.approved,
    decisionDate: '06/25/2026',
  ),
  PaymentReqModel(
    id: 'FPR01871',
    department: 'FAD',
    date: '06/23/2026',
    amount: 6750000,
    assignee: 'Д. Эрдэм-Од',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 4,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01872',
    department: 'PUR',
    date: '06/24/2026',
    amount: 12000000,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/24/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'FAD',
    date: '06/22/2026',
    amount: 1010200,
    assignee: 'М. Баасанжаргал',
    assigneeRole: '',
    assigneeLore: '',
    paymentDate: '06/24/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.rejected,
    decisionDate: '06/25/2026',
  ),
];
