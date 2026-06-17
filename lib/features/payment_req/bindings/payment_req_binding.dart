import 'package:get/get.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/data/payment_req_repository.dart';

class PaymentReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentReqRepository>(() => PaymentReqRepositoryImpl());
    Get.lazyPut<PaymentReqController>(() => PaymentReqController());
  }
}
