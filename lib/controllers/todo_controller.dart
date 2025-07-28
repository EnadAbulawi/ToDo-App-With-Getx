import 'package:get/get.dart';
import 'package:todo_app_getx/models/todo.dart';
import 'package:todo_app_getx/services/notification_service.dart';
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

  final _notif = Get.find<NotificationService>();

  // قائمة الفئات المتاحة
  final List<String> categories = ['عام', 'عمل', 'دراسة', 'شخصي'];
  @override
  void onInit() {
    super.onInit();
    // 1. تحميل المهام عند بدء التشغيل
    todos.assignAll(_storage.readTodos());
    // 2. الاستماع لأي تغيير في القائمة وحفظه تلقائياً
    ever<List<Todo>>(todos, (_) => _storage.writeTodos(todos));
  }

  // إضافة مهمة جديدة
  void addTodo(
    String title,
    String description,
    DateTime? dueDate,
    String category,
    Priority priority,
  ) {
    final todo = Todo(
      title: title,
      description: description,
      dueDate: dueDate,
      category: category,
      priority: priority,
    );
    todos.add(todo);
    // جدولة الإشعار إذا حُدِّد موعد
    if (dueDate != null) {
      _notif.scheduleNotification(
        id: todo.id.hashCode, // استخدام hashCode لضمان id مناسب
        title: 'موعد المهمة: ${todo.title}',
        body: todo.description,
        scheduledDate: dueDate,
      );
    }
  }

  // تعديل مهمة موجودة
  void updateTodo(
    String id,
    String title,
    String description,
    DateTime? dueDate,
    String category,
    Priority priority,
  ) {
    final idx = todos.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final old = todos[idx];
      old.title = title;
      old.description = description;
      old.dueDate = dueDate;
      old.category = category;
      old.priority = priority;
      todos.refresh();

      final nid = id.hashCode;
      // أولاً نلغي الإشعار القديم
      _notif.cancelNotification(nid);

      // ثم نعيد الجدولة إذا بقي موعد
      if (dueDate != null) {
        _notif.scheduleNotification(
          id: nid,
          title: 'موعد المهمة: $title',
          body: description,
          scheduledDate: dueDate,
        );
      }
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
    final nid = id.hashCode;
    // إلغاء الإشعار عند حذف المهمة
    _notif.cancelNotification(nid);
  }

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

  /// يعيد ترتيب قائمة todos
  /// [oldIndex] هو موضع العنصر المسحوب أصلاً
  /// [newIndex] هو الموضع الذي سُحب إليه (بعد تحويله)
  void reorderTodos(int oldIndex, int newIndex) {
    // عند رفع العنصر للأعلى، newIndex يكون أكبر بمقدار 1
    if (newIndex > oldIndex) newIndex--;
    final item = todos.removeAt(oldIndex);
    todos.insert(newIndex, item);
    // بما أن ever() ربط الحفظ تلقائيًا مع todos، سيُحفظ الترتيب الجديد
  }

  // حساب عدد المهام في كل فئة
  Map<String, int> get categoryCounts {
    return {
      for (var cat in categories)
        cat: todos.where((t) => t.category == cat).length,
    };
  }
}
