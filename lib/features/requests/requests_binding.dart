import 'package:get/get.dart';
import 'package:ncapp/features/requests/requests_controller.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestsController());
  }
}