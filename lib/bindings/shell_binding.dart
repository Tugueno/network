import 'package:get/get.dart';
import 'package:ncapp/controllers/shell_controller.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/requests/requests_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShellController>(() => ShellController());
    Get.lazyPut<RequestsController>(() => RequestsController());
    Get.lazyPut<PaymentReqController>(() => PaymentReqController());
    Get.lazyPut<AdvanceReqController>(() => AdvanceReqController());
  }
}
