import 'package:get/get.dart';
import 'package:ncapp/app/main_tab_shell.dart';

class MainTabController extends GetxController {
  final currentIndex = MainTab.home.index.obs;

  MainTab get currentTab => MainTab.values[currentIndex.value];

  void selectTab(MainTab tab) {
    currentIndex.value = tab.index;
  }
}
