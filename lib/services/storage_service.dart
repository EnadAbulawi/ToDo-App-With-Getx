import 'package:get_storage/get_storage.dart';
import 'package:todo_app_getx/models/todo.dart';

class StorageService {
  static const String _boxKey = 'todos';
  final _box = GetStorage();

  /// تحميل المهام من الـ GetStorage
  List<Todo> readTodos() {
    final data = _box.read<List<dynamic>>(_boxKey);
    if (data == null) return [];
    return data.map((e) => Todo.fromJson(Map.from(e))).toList();
  }

  /// حفظ المهام في الـ GetStorage
  void writeTodos(List<Todo> todos) =>
      _box.write(_boxKey, todos.map((t) => t.toJson()).toList());

  /// حذف جميع المهام من الـ GetStorage
  void clearTodos() {
    _box.remove(_boxKey);
  }
}
