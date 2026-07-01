import 'package:get/get.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/data/payment_req_repository.dart';

class PaymentReqBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PaymentReqRepository>()) {
      Get.lazyPut<PaymentReqRepository>(() => PaymentReqRepositoryImpl());
    }
    if (!Get.isRegistered<PaymentReqController>()) {
      Get.lazyPut<PaymentReqController>(() => PaymentReqController());
    }
  }
}
