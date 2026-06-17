enum AdvanceReqStatus { pending, closed }

class AdvanceReqModel {
  final String id;
  final String date;
  final int usedAmount;
  final int totalAmount;
  final int remainingAmount;
  final int totalCloseAmount;
  final int attachmentCount;
  final AdvanceReqStatus status;

  const AdvanceReqModel({
    required this.id,
    required this.date,
    required this.usedAmount,
    required this.totalAmount,
    this.remainingAmount = 0,
    this.totalCloseAmount = 0,
    this.attachmentCount = 0,
    this.status = AdvanceReqStatus.pending,
  });
}
