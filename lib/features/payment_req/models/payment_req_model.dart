import 'package:ncapp/core/utils/format.dart';

// ── Attachment models ──────────────────────────────────────
class AttachmentFile {
  final String name;
  final String url;
  final String assetPath;

  const AttachmentFile({
    required this.name,
    this.url = '',
    this.assetPath = '',
  });

  factory AttachmentFile.fromJson(Map<String, dynamic> j) => AttachmentFile(
    name: j['name'] ?? '',
    url: j['url'] ?? '',
    assetPath: j['assetPath'] ?? '',
  );
}

class AttachmentGroup {
  final String personName;
  final String personRole;
  final String avatarUrl;
  final String date;
  final List<AttachmentFile> files;

  const AttachmentGroup({
    required this.personName,
    required this.personRole,
    this.avatarUrl = '',
    required this.date,
    required this.files,
  });

  factory AttachmentGroup.fromJson(Map<String, dynamic> j) => AttachmentGroup(
    personName: j['personName'] ?? '',
    personRole: j['personRole'] ?? '',
    avatarUrl: j['avatarUrl'] ?? '',
    date: j['date'] ?? '',
    files: (j['files'] as List? ?? [])
        .map((f) => AttachmentFile.fromJson(f))
        .toList(),
  );
}

// ── Detail item ────────────────────────────────────────────
class DetailItem {
  final String subtitle;
  final String info;
  const DetailItem({required this.subtitle, required this.info});
}

// ── Approval step ──────────────────────────────────────────
enum ApprovalStepStatus { done, active, pending }

class ApprovalStepModel {
  final String label;
  final String person;
  final String? comment;
  final String? message;
  final String date;
  final ApprovalStepStatus status;
  final bool isReturned;

  ApprovalStepModel({
    required this.label,
    required this.person,
    this.comment,
    this.message,
    required this.date,
    required this.status,
    this.isReturned = false,
  });

  factory ApprovalStepModel.fromJson(Map<String, dynamic> j) =>
      ApprovalStepModel(
        label: j['label'] ?? '',
        person: j['person'] ?? '',
        comment: j['comment'],
        message: j['message'],
        date: j['date'] ?? '',
        status: ApprovalStepStatus.values.firstWhere(
          (s) => s.name == j['status'],
          orElse: () => ApprovalStepStatus.pending,
        ),
        isReturned: j['isReturned'] ?? false,
      );
}

// ── Payment request ────────────────────────────────────────
enum PaymentReqStatus { pending, approved, rejected }

class PaymentReqModel {
  final String id;
  final String department;
  final String date;
  final int amount;
  final String assignee;
  final String assigneeRole;
  final String assigneeLore;
  final String avatarUrl;
  final String paymentDate;
  final String company;
  final String description;
  final int attachmentCount;
  final List<AttachmentGroup> attachmentGroups;
  final List<ApprovalStepModel> approvalSteps;
  final PaymentReqStatus status;
  final String decisionDate; // approved/returned date
  final List<DetailItem> requestDetails;
  final List<DetailItem> budgetDetails;

  PaymentReqModel({
    required this.id,
    required this.department,
    required this.date,
    required this.amount,
    required this.assignee,
    required this.assigneeRole,
    required this.assigneeLore,
    this.avatarUrl = '',
    required this.paymentDate,
    required this.company,
    required this.description,
    this.attachmentCount = 0,
    this.attachmentGroups = const [],
    this.approvalSteps = const [],
    this.status = PaymentReqStatus.pending,
    this.decisionDate = '',
    this.requestDetails = const [],
    this.budgetDetails = const [],
  });

  factory PaymentReqModel.fromJson(Map<String, dynamic> j) => PaymentReqModel(
    id: j['id'] ?? '',
    department: j['department'] ?? '',
    date: j['date'] ?? '',
    amount: j['amount'] ?? 0,
    assignee: j['assignee'] ?? '',
    assigneeRole: j['assigneeRole'] ?? '',
    assigneeLore: j['assigneeLore'] ?? '',
    avatarUrl: j['avatarUrl'] ?? '',
    paymentDate: j['paymentDate'] ?? '',
    company: j['company'] ?? '',
    description: j['description'] ?? '',
    attachmentCount: j['attachmentCount'] ?? 0,
    attachmentGroups: (j['attachmentGroups'] as List? ?? [])
        .map((g) => AttachmentGroup.fromJson(g))
        .toList(),
    approvalSteps: (j['approvalSteps'] as List? ?? [])
        .map((s) => ApprovalStepModel.fromJson(s))
        .toList(),
    status: PaymentReqStatus.values.firstWhere(
      (s) => s.name == j['status'],
      orElse: () => PaymentReqStatus.pending,
    ),
    decisionDate: j['decisionDate'] ?? '',
    requestDetails: (j['requestDetails'] as List? ?? [])
        .map(
          (d) =>
              DetailItem(subtitle: d['subtitle'] ?? '', info: d['info'] ?? ''),
        )
        .toList(),
    budgetDetails: (j['budgetDetails'] as List? ?? [])
        .map(
          (d) =>
              DetailItem(subtitle: d['subtitle'] ?? '', info: d['info'] ?? ''),
        )
        .toList(),
  );

  PaymentReqModel copyWith({PaymentReqStatus? status, String? decisionDate}) =>
      PaymentReqModel(
        id: id,
        department: department,
        date: date,
        amount: amount,
        assignee: assignee,
        assigneeRole: assigneeRole,
        assigneeLore: assigneeLore,
        avatarUrl: avatarUrl,
        paymentDate: paymentDate,
        company: company,
        description: description,
        attachmentCount: attachmentCount,
        attachmentGroups: attachmentGroups,
        approvalSteps: approvalSteps,
        status: status ?? this.status,
        decisionDate: decisionDate ?? this.decisionDate,
        requestDetails: requestDetails,
        budgetDetails: budgetDetails,
      );

  String get formattedAmount => formatTugrik(amount);

  /// Month parsed from [date] (MM/dd/yyyy), 0 if unparsable.
  int get month => int.tryParse(date.split('/').first) ?? 0;

  /// Full date parsed from [date] (MM/dd/yyyy), null if unparsable.
  DateTime? get dateTime {
    final p = date.split('/');
    if (p.length != 3) return null;
    final m = int.tryParse(p[0]);
    final d = int.tryParse(p[1]);
    final y = int.tryParse(p[2]);
    if (m == null || d == null || y == null) return null;
    return DateTime(y, m, d);
  }
}
