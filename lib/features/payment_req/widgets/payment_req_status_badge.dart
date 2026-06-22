import 'package:flutter/material.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_status_ui.dart';

class PaymentReqStatusBadge extends StatelessWidget {
  final PaymentReqStatus status;

  const PaymentReqStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status.icon, size: 16, color: status.color),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: TextStyle(
            fontSize: 14,
            color: status.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
