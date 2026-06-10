import 'package:get/get.dart';
import '../models/payment_req_model.dart';

class PaymentReqController extends GetxController {
  // ── State ─────────────────────────────────────────────────
  final items = <PaymentReqModel>[].obs;
  final isLoading = true.obs;
  final selectedItem = Rxn<PaymentReqModel>();

  // ── Computed ──────────────────────────────────────────────
  List<PaymentReqModel> get pending =>
      items.where((r) => r.status == PaymentReqStatus.pending).toList();

  int get totalAmount => pending.fold(0, (s, r) => s + r.amount);
  int get pendingCount => pending.length;
  int get approvedCount =>
      items.where((r) => r.status == PaymentReqStatus.approved).length;

  String get formattedTotal {
    final s = totalAmount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write("'");
      buf.write(s[i]);
    }
    return "${buf.toString()}₮";
  }

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  // ── Actions ───────────────────────────────────────────────
  Future<void> fetchRequests() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // replace with API call
    items.value = _mockData;
    isLoading.value = false;
  }

  void openDetail(PaymentReqModel item) {
    selectedItem.value = item;
    Get.toNamed('/paymentreq/detail');
  }

  Future<void> approve(PaymentReqModel item) async {
    // TODO: call API
    final index = items.indexWhere((r) => r.id == item.id);
    if (index == -1) return;
    // optimistic update — replace with real API response
    Get.back();
  }

  Future<void> reject(PaymentReqModel item) async {
    // TODO: call API
    Get.back();
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
    paymentDate: '06/22/2026',
    company: 'Нэткaпитал Финанс Корпораци...',
    description:
        'Удирлагын зөвлөлийн ээлжит уулзалтын зохион байгуулат болон логистикийн зардал (хоол унд, хэвлэл ба сургалтын материал).',
    attachmentCount: 3,
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
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01866',
    department: 'HR',
    date: '06/22/2026',
    amount: 2000000,
    assignee: 'Д. Эрдэм-Од',
    assigneeRole: '',
    paymentDate: '06/22/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.approved,
  ),
  PaymentReqModel(
    id: 'FPR01867',
    department: 'PUR',
    date: '06/22/2026',
    amount: 740100,
    assignee: 'А. Жавхлан',
    assigneeRole: '',
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
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
  PaymentReqModel(
    id: 'FPR01870',
    department: 'HR',
    date: '06/23/2026',
    amount: 800000,
    assignee: 'С. Мөнхзул',
    assigneeRole: '',
    paymentDate: '06/23/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.approved,
  ),
  PaymentReqModel(
    id: 'FPR01871',
    department: 'FAD',
    date: '06/23/2026',
    amount: 6750000,
    assignee: 'Д. Эрдэм-Од',
    assigneeRole: '',
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
    paymentDate: '06/24/2026',
    company: '',
    description: '',
    attachmentCount: 0,
    status: PaymentReqStatus.pending,
  ),
];
