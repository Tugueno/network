import 'package:get/get.dart';
import '../controllers/payment_req_controller.dart';

class PaymentReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentReqController>(() => PaymentReqController());
  }
}
