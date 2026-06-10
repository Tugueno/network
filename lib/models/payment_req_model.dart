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
  final String avatarUrl;
  final String paymentDate;
  final String company;
  final String description;
  final int attachmentCount;
  final List<ApprovalStepModel> approvalSteps;
  final PaymentReqStatus status;
  final List<DetailItem> requestDetails;
  final List<DetailItem> budgetDetails;

  PaymentReqModel({
    required this.id,
    required this.department,
    required this.date,
    required this.amount,
    required this.assignee,
    required this.assigneeRole,
    this.avatarUrl = '',
    required this.paymentDate,
    required this.company,
    required this.description,
    this.attachmentCount = 0,
    this.approvalSteps = const [],
    this.status = PaymentReqStatus.pending,
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
        avatarUrl: j['avatarUrl'] ?? '',
        paymentDate: j['paymentDate'] ?? '',
        company: j['company'] ?? '',
        description: j['description'] ?? '',
        attachmentCount: j['attachmentCount'] ?? 0,
        approvalSteps: (j['approvalSteps'] as List? ?? [])
            .map((s) => ApprovalStepModel.fromJson(s))
            .toList(),
        status: PaymentReqStatus.values.firstWhere(
          (s) => s.name == j['status'],
          orElse: () => PaymentReqStatus.pending,
        ),
        requestDetails: (j['requestDetails'] as List? ?? [])
            .map((d) => DetailItem(subtitle: d['subtitle'] ?? '', info: d['info'] ?? ''))
            .toList(),
        budgetDetails: (j['budgetDetails'] as List? ?? [])
            .map((d) => DetailItem(subtitle: d['subtitle'] ?? '', info: d['info'] ?? ''))
            .toList(),
      );

  String get formattedAmount {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write("'");
      buf.write(s[i]);
    }
    return "${buf.toString()}₮";
  }
}
