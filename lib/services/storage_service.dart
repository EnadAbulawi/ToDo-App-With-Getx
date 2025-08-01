import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:todo_app_getx/models/todo.dart';

class StorageService {
  static const String _boxKey = 'todos';
  final _box = GetStorage();

  /// تحميل المهام من الـ GetStorage
  List<Todo> readTodos() {
    final raw = _box.read<List<dynamic>>(_boxKey);
    log('>> قراءة خام: $raw');
    if (raw == null) return [];

    return raw.map((e) {
      final Map<String, dynamic> json = Map.from(e as Map);
      // تأكد من وجود مفتاح 'category' و'priority' حتى على البيانات القديمة
      if (!json.containsKey('category')) {
        json['category'] = 'عام';
      }
      if (!json.containsKey('priority')) {
        json['priority'] = Priority.medium.toString();
      }
      return Todo.fromJson(json);
    }).toList();
  }

  /// حفظ المهام في الـ GetStorage
  void writeTodos(List<Todo> todos) {
    final list = todos.map((t) => t.toJson()).toList();
    log('>> حفظ خام: $list'); // يجب أن ترى "category":"شخصي" مثلاً
    _box.write(_boxKey, list);
  }

  /// **للتنظيف**: تفريغ البيانات القديمة إذا أردت تجربة نظيفة
  void clearTodos() async {
    await _box.remove(_boxKey);
  }
}
