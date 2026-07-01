import 'package:get/get.dart';
import 'package:ncapp/widgets/main_tab_navigation_bar.dart';

class MainTabController extends GetxController {
  final currentIndex = MainTab.home.index.obs;

  MainTab get currentTab => MainTab.values[currentIndex.value];

  void selectTab(MainTab tab) {
    currentIndex.value = tab.index;
  }
}
