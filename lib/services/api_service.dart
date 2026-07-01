import 'package:dio/dio.dart';

class ApiService {
  static const _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.19.92:4000/api',
  );

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  /// Fetch leave requests filtered by state: 'confirm' | 'validate' | 'refuse'
  Future<List<Map<String, dynamic>>> fetchLeaveList(String state) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/leave_approval_list',
      data: {'state': state},
    );
    final items = res.data?['items'] as List? ?? [];
    return items.cast<Map<String, dynamic>>();
  }

  /// Employees who currently have leave requests (for the filter panel).
  Future<List<Map<String, dynamic>>> fetchEmployeeOptions() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/leave_employee_filter_options',
    );
    final items = res.data?['items'] as List? ?? [];
    return items.cast<Map<String, dynamic>>();
  }

  /// Approve or refuse leave requests by their IDs.
  /// [action] must be 'approve' or 'refuse'.
  Future<bool> doAction({
    required String action,
    required List<int> leaveIds,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/leave_approval_action',
      data: {'action': action, 'leaveIds': leaveIds},
    );
    return res.data?['ok'] == true;
  }
}
