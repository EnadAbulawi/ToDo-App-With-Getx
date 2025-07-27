import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TodoController());
    // أو يمكنك استخدام Get.lazyPut إذا كنت تريد تحميل الـ Controller عند الحاجة فقط
  }
}
