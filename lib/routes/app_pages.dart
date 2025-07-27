import 'package:get/get.dart';
import 'package:todo_app_getx/bindings/add_edit_binding.dart';
import 'package:todo_app_getx/bindings/home_binding.dart';
import 'package:todo_app_getx/views/add_edit_view.dart';
import 'package:todo_app_getx/views/home_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // GetPage(
    //   name: AppRoutes.SPLASH,
    //   page: () => const SplashScreen(),
    //   // binding: SplashBinding(),
    // ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_EDIT,
      page: () => AddEditView(),
      binding: AddEditBinding(),
    ),
  ];
}
