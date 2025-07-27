import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class AddEditBinding extends Bindings {
  @override
  void dependencies() {
    // نستخدم نفس الـ Controller لتمرير بيانات المهمة عند التعديل
    Get.lazyPut<TodoController>(() => TodoController());
  }
}
