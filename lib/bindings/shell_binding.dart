import 'package:get/get.dart';
import 'package:ncapp/controllers/shell_controller.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/data/payment_req_repository.dart';
import 'package:ncapp/features/requests/requests_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ShellController>()) {
      Get.lazyPut<ShellController>(() => ShellController());
    }
    if (!Get.isRegistered<RequestsController>()) {
      Get.lazyPut<RequestsController>(() => RequestsController());
    }
    if (!Get.isRegistered<PaymentReqRepository>()) {
      Get.lazyPut<PaymentReqRepository>(() => PaymentReqRepositoryImpl());
    }
    if (!Get.isRegistered<PaymentReqController>()) {
      Get.lazyPut<PaymentReqController>(() => PaymentReqController());
    }
    if (!Get.isRegistered<AdvanceReqController>()) {
      Get.lazyPut<AdvanceReqController>(() => AdvanceReqController());
    }
  }
}
