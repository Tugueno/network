import 'package:get/get.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/services/api_service.dart';

class RequestsController extends GetxController {
  final _api = ApiService();

  // Tab: 0=Ирсэн, 1=Зөвшөөрсөн, 2=Цуцалсан
  final selectedTab = 0.obs;
  final allRequests = <RequestModel>[].obs;
  final employees = <EmployeeModel>[].obs;
  final isLoading = false.obs;

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
      list = list
          .where((r) => appliedEmployeeIds.contains(r.employeeId))
          .toList();
    }
    if (appliedTypes.isNotEmpty) {
      list = list.where((r) => appliedTypes.contains(r.type)).toList();
    }
    return list;
  }

  int get selectedCount =>
      allRequests.where((r) => r.isSelected.value).length;

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

  // ── Data loading ───────────────────────────────────────────

  Future<void> _loadEmployees() async {
    try {
      final data = await _api.fetchEmployeeOptions();
      employees.assignAll(data.map((j) => EmployeeModel(
            id: (j['employee_id'] ?? '').toString(),
            name: (j['employee_name'] ?? '').toString(),
            role: (j['job_title'] ?? '').toString(),
          )));
    } catch (_) {}
  }

  /// Fetches all three states in parallel and merges into [allRequests].
  Future<void> loadRequests() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _api.fetchLeaveList('confirm'),   // → irsen (pending)
        _api.fetchLeaveList('validate'),  // → zuvshuursun (approved)
        _api.fetchLeaveList('refuse'),    // → tsutsalsan (cancelled)
      ]);
      allRequests.assignAll(
        results.expand((list) => list.map(_fromApiItem)),
      );
    } catch (_) {
      _showToast('Өгөгдөл татахад алдаа гарлаа');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Selection ──────────────────────────────────────────────

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

  // ── Actions ────────────────────────────────────────────────

  Future<void> approve() async {
    final selected = allRequests.where((r) => r.isSelected.value).toList();
    final ids = selected
        .map((r) => int.tryParse(r.id))
        .whereType<int>()
        .toList();

    if (ids.isNotEmpty) {
      try {
        await _api.doAction(action: 'approve', leaveIds: ids);
      } catch (_) {
        _showToast('Батлахад алдаа гарлаа');
        return;
      }
    }

    for (final r in selected) {
      r.status.value = RequestStatus.zuvshuursun;
      r.isSelected.value = false;
    }
    _showToast('${selected.length} ирцийн хүсэлт батлагдлаа.');
  }

  Future<void> reject() async {
    final selected = allRequests.where((r) => r.isSelected.value).toList();
    final ids = selected
        .map((r) => int.tryParse(r.id))
        .whereType<int>()
        .toList();
    final isApproved = selectedTab.value == 1;

    if (ids.isNotEmpty) {
      try {
        await _api.doAction(action: 'refuse', leaveIds: ids);
      } catch (_) {
        _showToast('Цуцлахад алдаа гарлаа');
        return;
      }
    }

    for (final r in selected) {
      r.status.value = RequestStatus.tsutsalsan;
      r.isSelected.value = false;
    }
    final msg = isApproved
        ? '${selected.length} зөвшөөрсөн ирцийн хүсэлт цуцлагдлаа.'
        : '${selected.length} ирцийн хүсэлт цуцлагдлаа.';
    _showToast(msg);
  }

  void _showToast(String message) {
    toastMessage.value = message;
    toastVisible.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      toastVisible.value = false;
    });
  }

  // ── Filter ─────────────────────────────────────────────────

  void initFilterFromApplied() {
    filterMonthIndex.value = appliedMonthIndex.value;
    filterTypes.assignAll(appliedTypes.toList());
    for (final e in employees) {
      e.isSelected.value = appliedEmployeeIds.contains(e.id);
    }
  }

  void toggleFilterMonth(int index) => filterMonthIndex.value = index;

  void toggleFilterType(RequestType type) {
    if (filterTypes.contains(type)) {
      filterTypes.remove(type);
    } else {
      filterTypes.add(type);
    }
  }

  void toggleEmployee(String id) {
    employees.firstWhereOrNull((e) => e.id == id)?.isSelected.toggle();
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

  // ── API → model mapping ────────────────────────────────────

  static RequestModel _fromApiItem(Map<String, dynamic> j) {
    final state = j['state'] as String? ?? 'confirm';
    final status = state == 'validate'
        ? RequestStatus.zuvshuursun
        : state == 'refuse'
            ? RequestStatus.tsutsalsan
            : RequestStatus.irsen;

    DateTime sentAt = DateTime.now();
    final rawDate = j['create_date'] as String? ?? '';
    if (rawDate.isNotEmpty) {
      try {
        sentAt = DateTime.parse(rawDate);
      } catch (_) {}
    }

    final startTime = j['start_time'] as String? ?? '';
    final endTime = j['end_time'] as String? ?? '';
    final timeRange = (startTime.isNotEmpty && endTime.isNotEmpty)
        ? '$startTime - $endTime'
        : startTime;

    final startLabel = j['start_date_label'] as String? ?? '';
    final endLabel = j['end_date_label'] as String? ?? '';
    final duration = j['duration_display'] as String? ?? '';
    final datePart = (startLabel.isNotEmpty && endLabel.isNotEmpty && startLabel != endLabel)
        ? '$startLabel - $endLabel'
        : startLabel;
    final dateRange = [datePart, duration].where((s) => s.isNotEmpty).join(' · ');

    return RequestModel(
      id: (j['leave_id'] ?? 0).toString(),
      employeeId: (j['employee_id'] ?? '').toString(),
      type: _mapType(j['holiday_status_name'] as String? ?? ''),
      timeRange: timeRange,
      dateRange: dateRange,
      reason: j['reason'] as String? ?? '',
      senderName: j['employee_name'] as String? ?? '',
      senderAvatar: '',
      sentAt: sentAt,
      totalHours: 0,
      fileUrl: (j['has_attachments'] == true) ? 'attachment' : null,
      initialStatus: status,
    );
  }

  static RequestType _mapType(String name) {
    final n = name.toLowerCase();
    if (n.contains('гадуур')) return RequestType.gaduurAjillasan;
    if (n.contains('өвчн') || n.contains('эмчилгэ')) return RequestType.uvchiniiChuluu;
    if (n.contains('цалингүй')) return RequestType.tsalinguiChuluu;
    if (n.contains('аав')) return RequestType.aaviin10Honog;
    if (n.contains('ээлж') || n.contains('амралт')) return RequestType.eeljiinAmralt;
    if (n.contains('төрсөн')) return RequestType.tursunUdriinChuluu;
    if (n.contains('school') || n.contains('police')) return RequestType.schoolPolice;
    if (n.contains('ар гэр') || n.contains('гачигдал')) return RequestType.arGeriin;
    return RequestType.ajillasan;
  }
}
