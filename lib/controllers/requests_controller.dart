import 'package:get/get.dart';
import '../models/request_model.dart';

class RequestsController extends GetxController {
  // Tab: 0=Ирсэн, 1=Зөвшөөрсөн, 2=Цуцалсан
  final selectedTab = 0.obs;
  final allRequests = <RequestModel>[].obs;
  final employees = <EmployeeModel>[].obs;

  // Filter temp state (inside filter sheet before applying)
  final filterMonthIndex = 0.obs;
  final filterTypes = <RequestType>[].obs;

  // Applied filter state (affects main list)
  final appliedMonthIndex = 0.obs;
  final appliedEmployeeIds = <String>[].obs;
  final appliedTypes = <RequestType>[].obs;

  // Toast
  final toastMessage = ''.obs;
  final toastVisible = false.obs;

  final months = ['6-р сар Бүтэн', '6-р сар 1-15', '5-р сар', '4-р сар'];

  List<RequestModel> get filtered {
    final status = [
      RequestStatus.irsen,
      RequestStatus.zuvshuursun,
      RequestStatus.tsutsalsan,
    ][selectedTab.value];
    var list = allRequests.where((r) => r.status.value == status).toList();
    if (appliedEmployeeIds.isNotEmpty) {
      list = list.where((r) => appliedEmployeeIds.contains(r.employeeId)).toList();
    }
    if (appliedTypes.isNotEmpty) {
      list = list.where((r) => appliedTypes.contains(r.type)).toList();
    }
    return list;
  }

  int get selectedCount => allRequests.where((r) => r.isSelected.value).length;

  int countOf(RequestStatus s) =>
      allRequests.where((r) => r.status.value == s).length;

  List<RequestModel> get selectedItems =>
      allRequests.where((r) => r.isSelected.value).toList();

  List<EmployeeModel> get appliedEmployees =>
      employees.where((e) => appliedEmployeeIds.contains(e.id)).toList();

  @override
  void onInit() {
    super.onInit();
    _loadEmployees();
    loadRequests();
  }

  void _loadEmployees() {
    employees.assignAll([
      EmployeeModel(id: 'e1', name: 'Б. Батцэцэг', role: 'Бүтээгдэхүүн хариуцагч'),
      EmployeeModel(id: 'e2', name: 'Б. Хонгорзул', role: 'Бүтээгдэхүүн хариуцагч'),
      EmployeeModel(id: 'e3', name: 'Б. Хатанболд', role: 'Бүтээгдэхүүн хариуцагч'),
      EmployeeModel(
          id: 'e4',
          name: 'Э. Энхзул',
          role: 'Ахлах программ хөгжүүлэлтийн чанарын инженер'),
      EmployeeModel(
          id: 'e5',
          name: 'Д. Сараа',
          role: 'Программ хөгжүүлэлтийн чанарын инженер'),
      EmployeeModel(id: 'e6', name: 'Б. Болортуул', role: 'Ахлах менежер'),
    ]);
  }

  void loadRequests() {
    allRequests.assignAll([
      RequestModel(
        id: '1',
        employeeId: 'e3',
        type: RequestType.ajillasan,
        timeRange: '10:00 - 14:00',
        dateRange: '6 сарын 22 · Хагас өдөр · Цалинтай',
        reason: 'Өглөөний ирцээ мартсан тул',
        senderName: 'Б. Хатанболд',
        senderAvatar: '',
        sentAt: DateTime(2025, 11, 1, 8, 14),
        totalHours: 8,
        initialStatus: RequestStatus.irsen,
      ),
      RequestModel(
        id: '2',
        employeeId: 'e3',
        type: RequestType.ajillasan,
        timeRange: '10:00 - 19:00',
        dateRange: '6 сарын 22 - 25 · Хоногоор · Цалинтай',
        reason: 'Өглөөний ирцээ мартсан тул',
        senderName: 'Б. Хатанболд',
        senderAvatar: '',
        sentAt: DateTime(2025, 11, 1, 8, 14),
        totalHours: 32,
        initialStatus: RequestStatus.irsen,
      ),
      RequestModel(
        id: '3',
        employeeId: 'e3',
        type: RequestType.uvchiniiChuluu,
        timeRange: '10:00 - 19:00',
        dateRange: '6 сарын 22 - 25 · Хоногоор · Цалинтай',
        reason: 'Ханиад хүрсэн 4 өдрийн өвчний чөлөо ...',
        senderName: 'Б. Хатанболд',
        senderAvatar: '',
        sentAt: DateTime(2025, 11, 1, 8, 14),
        totalHours: 24,
        fileUrl: 'https://example.com/file.pdf',
        initialStatus: RequestStatus.irsen,
      ),
      RequestModel(
        id: '4',
        employeeId: 'e3',
        type: RequestType.ajillasan,
        timeRange: '10:00 - 14:00',
        dateRange: '6 сарын 22 · Хагас өдөр · Цалинтай',
        reason: 'Өглөөний ирцээ мартсан тул',
        senderName: 'Б. Хатанболд',
        senderAvatar: '',
        sentAt: DateTime(2025, 11, 1, 8, 14),
        totalHours: 8,
        initialStatus: RequestStatus.zuvshuursun,
      ),
      RequestModel(
        id: '5',
        employeeId: 'e3',
        type: RequestType.ajillasan,
        timeRange: '10:00 - 19:00',
        dateRange: '6 сарын 22 - 25 · Хоногоор · Цалинтай',
        reason: 'Өглөөний ирцээ мартсан тул',
        senderName: 'Б. Хатанболд',
        senderAvatar: '',
        sentAt: DateTime(2025, 11, 1, 8, 14),
        totalHours: 32,
        initialStatus: RequestStatus.zuvshuursun,
      ),
    ]);
  }

  // ── Selection ──────────────────────────────────────────

  void toggleSelect(String id) {
    final item = allRequests.firstWhereOrNull((r) => r.id == id);
    if (item == null) return;
    item.isSelected.value = !item.isSelected.value;
  }

  void clearSelection() {
    for (final r in allRequests) {
      r.isSelected.value = false;
    }
  }

  // ── Actions ────────────────────────────────────────────

  void approve() {
    final count = selectedCount;
    for (final r in allRequests) {
      if (r.isSelected.value) {
        r.status.value = RequestStatus.zuvshuursun;
        r.isSelected.value = false;
      }
    }
    _showToast('$count ирцийн хүсэлт батлагдлаа.');
  }

  void reject() {
    final count = selectedCount;
    final isApproved = selectedTab.value == 1;
    for (final r in allRequests) {
      if (r.isSelected.value) {
        r.status.value = RequestStatus.tsutsalsan;
        r.isSelected.value = false;
      }
    }
    final msg = isApproved
        ? '$count зөвшөөрсөн ирцийн хүсэлт цуцлагдлаа.'
        : '$count ирцийн хүсэлт цуцлагдлаа.';
    _showToast(msg);
  }

  void _showToast(String message) {
    toastMessage.value = message;
    toastVisible.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      toastVisible.value = false;
    });
  }

  // ── Filter ─────────────────────────────────────────────

  void initFilterFromApplied() {
    filterMonthIndex.value = appliedMonthIndex.value;
    filterTypes.assignAll(appliedTypes.toList());
    for (final e in employees) {
      e.isSelected.value = appliedEmployeeIds.contains(e.id);
    }
  }

  void toggleFilterMonth(int index) {
    filterMonthIndex.value = index;
  }

  void toggleFilterType(RequestType type) {
    if (filterTypes.contains(type)) {
      filterTypes.remove(type);
    } else {
      filterTypes.add(type);
    }
  }

  void toggleEmployee(String id) {
    final emp = employees.firstWhereOrNull((e) => e.id == id);
    emp?.isSelected.toggle();
  }

  void applyFilter() {
    appliedMonthIndex.value = filterMonthIndex.value;
    appliedTypes.assignAll(filterTypes.toList());
    appliedEmployeeIds.assignAll(
      employees.where((e) => e.isSelected.value).map((e) => e.id).toList(),
    );
  }

  void removeAppliedEmployee(String id) {
    appliedEmployeeIds.remove(id);
    employees.firstWhereOrNull((e) => e.id == id)?.isSelected.value = false;
  }
}
