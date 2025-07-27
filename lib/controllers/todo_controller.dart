import 'package:get/get.dart';
import 'package:todo_app_getx/models/todo.dart';

class TodoController extends GetxController {
  // قائمة مهام تفاعلية
  var todos = <Todo>[].obs;

  // إضافة مهمة جديدة
  void addTodo(String title, String description) {
    final todo = Todo(title: title, description: description);
    todos.add(todo);
  }

  // تعديل مهمة موجودة
  void updateTodo(String id, String title, String description) {
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index].title = title;
      todos[index].description = description;
      todos.refresh();
    }
  }

  // تبديل حالة الإنجاز
  void toggleDone(String id) {
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index].done = !todos[index].done;
      todos.refresh();
    }
  }

  // حذف مهمة
  void deleteTodo(String id) {
    todos.removeWhere((t) => t.id == id);
  }
}
