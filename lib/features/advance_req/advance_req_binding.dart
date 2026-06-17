import 'package:get/get.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';

class AdvanceReqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvanceReqController>(() => AdvanceReqController());
  }
}
