import 'package:get/get.dart';
import 'package:ncapp/features/payment_req/payment_req_controller.dart';

class PaymentReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentReqController>(() => PaymentReqController());
  }
}
