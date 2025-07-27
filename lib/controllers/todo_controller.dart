import 'package:get/get.dart';
import 'package:todo_app_getx/models/todo.dart';
import 'package:todo_app_getx/services/storage_service.dart';

enum FilterStatus { all, completed, incomplete }

class TodoController extends GetxController {
  // قائمة مهام تفاعلية
  var todos = <Todo>[].obs;
  // خدمة التخزين
  final StorageService _storage = StorageService();

  //  حالة الفلترة (كل، مكتملة، غير مكتملة)
  var filterStatus = FilterStatus.all.obs;

  //  نص البحث
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. تحميل المهام عند بدء التشغيل
    todos.assignAll(_storage.readTodos());
    // 2. الاستماع لأي تغيير في القائمة وحفظه تلقائياً
    ever<List<Todo>>(todos, (_) => _storage.writeTodos(todos));
  }

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
  void deleteTodo(String id) => todos.removeWhere((t) => t.id == id);

  //Getter لإرجاع المهام بعد تطبيق الفلترة والبحث
  List<Todo> get filteredTodos {
    return todos.where((t) {
      // فلترة حسب الحالة
      if (filterStatus.value == FilterStatus.completed && !t.done) {
        return false;
      }
      if (filterStatus.value == FilterStatus.incomplete && t.done) {
        return false;
      }
      // فلترة حسب نص البحث
      if (searchQuery.value.isNotEmpty &&
          !t.title.toLowerCase().contains(searchQuery.value.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }
}
