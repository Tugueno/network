import 'package:get/get.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';

class AdvanceReqBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AdvanceReqController>()) {
      Get.lazyPut<AdvanceReqController>(() => AdvanceReqController());
    }
  }
}
