import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum RequestStatus { irsen, zuvshuursun, tsutsalsan }

enum RequestType {
  ajillasan,
  gaduurAjillasan,
  uvchiniiChuluu,
  tsalinguiChuluu,
  aaviin10Honog,
  eeljiinAmralt,
  tursunUdriinChuluu,
  schoolPolice,
  arGeriin,
}

extension RequestTypeX on RequestType {
  String get label {
    switch (this) {
      case RequestType.ajillasan:
        return 'Ажилласан';
      case RequestType.gaduurAjillasan:
        return 'Гадуур ажилласан';
      case RequestType.uvchiniiChuluu:
        return 'Өвчний чөлөө';
      case RequestType.tsalinguiChuluu:
        return 'Цалингүй чөлөө';
      case RequestType.aaviin10Honog:
        return 'Аавын 10 хоног';
      case RequestType.eeljiinAmralt:
        return 'Ээлжийн амралт';
      case RequestType.tursunUdriinChuluu:
        return 'Төрсөн өдрийн цалинтай чөлөө';
      case RequestType.schoolPolice:
        return 'School Police';
      case RequestType.arGeriin:
        return 'Ар гэрийн гачигдлын чөлөө';
    }
  }

  IconData get icon {
    switch (this) {
      case RequestType.ajillasan:
        return Icons.access_time_outlined;
      case RequestType.gaduurAjillasan:
        return Icons.domain_outlined;
      case RequestType.uvchiniiChuluu:
        return Icons.medication_outlined;
      case RequestType.tsalinguiChuluu:
        return Icons.timer_off_outlined;
      case RequestType.aaviin10Honog:
        return Icons.child_care_outlined;
      case RequestType.eeljiinAmralt:
        return Icons.beach_access_outlined;
      case RequestType.tursunUdriinChuluu:
        return Icons.cake_outlined;
      case RequestType.schoolPolice:
        return Icons.local_police_outlined;
      case RequestType.arGeriin:
        return Icons.warning_amber_outlined;
    }
  }
}

class EmployeeModel {
  final String id;
  final String name;
  final String role;
  final String? avatarUrl;
  final RxBool isSelected;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    this.avatarUrl,
    bool selected = false,
  }) : isSelected = selected.obs;
}

class RequestModel {
  final String id;
  final String employeeId;
  final RequestType type;
  final String timeRange;
  final String dateRange;
  final String reason;
  final String senderName;
  final String senderAvatar;
  final DateTime sentAt;
  final int totalHours;
  final String? fileUrl;
  final RxBool isSelected;
  final Rx<RequestStatus> status;

  RequestModel({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.timeRange,
    required this.dateRange,
    required this.reason,
    required this.senderName,
    required this.senderAvatar,
    required this.sentAt,
    required this.totalHours,
    this.fileUrl,
    RequestStatus initialStatus = RequestStatus.irsen,
    bool initialSelected = false,
  })  : status = initialStatus.obs,
        isSelected = initialSelected.obs;
}
