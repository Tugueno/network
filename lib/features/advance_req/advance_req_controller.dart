import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';

class AdvanceReqController extends GetxController {
  final items = <AdvanceReqModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final selectedItem = Rxn<AdvanceReqModel>();
  bool _detailRouteOpen = false;

  List<AdvanceReqModel> get pending =>
      items.where((r) => r.status == AdvanceReqStatus.pending).toList();

  List<AdvanceReqModel> get closed =>
      items.where((r) => r.status == AdvanceReqStatus.closed).toList();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future.delayed(
        const Duration(milliseconds: 600),
      ); // TODO: replace with API
      items.value = _mockData;
    } catch (_) {
      errorMessage.value = 'Урьдчилгааны хүсэлт татахад алдаа гарлаа';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => _load();

  Future<void> openDetail(
    AdvanceReqModel item, {
    required bool openInRoute,
  }) async {
    if (openInRoute && _detailRouteOpen) return;
    selectedItem.value = item;
    if (!openInRoute) return;

    _detailRouteOpen = true;
    try {
      await Get.toNamed(AppRoutes.advancereqDetail);
    } finally {
      _detailRouteOpen = false;
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (selectedItem.value == item) {
        selectedItem.value = null;
      }
    }
  }

  void closeDetail({bool popRoute = false}) {
    if (popRoute && Get.currentRoute == AppRoutes.advancereqDetail) {
      Get.back();
      return;
    }
    selectedItem.value = null;
  }
}

// ── Mock data ──────────────────────────────────────────────
final _mockData = [
  const AdvanceReqModel(
    id: 'FPR01866',
    date: '06/20/2025',
    usedAmount: 148000,
    totalAmount: 150000,
    remainingAmount: 230500,
    totalCloseAmount: 1130500,
    attachmentCount: 3,
    status: AdvanceReqStatus.pending,
  ),
  const AdvanceReqModel(
    id: 'FPR01867',
    date: '06/20/2025',
    usedAmount: 148000,
    totalAmount: 150000,
    remainingAmount: 80000,
    totalCloseAmount: 500000,
    attachmentCount: 1,
    status: AdvanceReqStatus.pending,
  ),
  const AdvanceReqModel(
    id: 'FPR01868',
    date: '06/20/2025',
    usedAmount: 148000,
    totalAmount: 150000,
    attachmentCount: 2,
    status: AdvanceReqStatus.closed,
  ),
  const AdvanceReqModel(
    id: 'FPR01869',
    date: '06/20/2025',
    usedAmount: 148000,
    totalAmount: 150000,
    attachmentCount: 0,
    status: AdvanceReqStatus.closed,
  ),
  const AdvanceReqModel(
    id: 'FPR01870',
    date: '06/20/2025',
    usedAmount: 148000,
    totalAmount: 150000,
    attachmentCount: 5,
    status: AdvanceReqStatus.closed,
  ),
  const AdvanceReqModel(
    id: 'FPR01871',
    date: '06/20/2025',
    usedAmount: 148000,
    totalAmount: 150000,
    attachmentCount: 0,
    status: AdvanceReqStatus.closed,
  ),
];
