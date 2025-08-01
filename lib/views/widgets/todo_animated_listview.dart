import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo.dart';
import 'package:intl/intl.dart';

class TodoAnimatedListView extends StatefulWidget {
  final TodoController controller;
  const TodoAnimatedListView({required this.controller, Key? key})
    : super(key: key);

  @override
  State<TodoAnimatedListView> createState() => _TodoAnimatedListViewState();
}

class _TodoAnimatedListViewState extends State<TodoAnimatedListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late List<Todo> _items;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    // 1) نحتفظ بنسخة محلية من القوائم
    _items = List.from(widget.controller.todos);
    // 2) نستمع لأي تغيير في الـ RxList
    _sub = widget.controller.todos.listen(_onTodosChanged);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  // 3) عند التغيير: نحدد عنصر مضاف أو محذوف
  void _onTodosChanged(List<Todo> newTodos) {
    final old = List<Todo>.from(_items);

    // 3a) إضافة
    if (newTodos.length > old.length) {
      // افترض أن العنصر المضاف في النهاية:
      final added = newTodos.last;
      final index = newTodos.indexOf(added);
      _items.insert(index, added);
      _listKey.currentState?.insertItem(
        index,
        duration: const Duration(milliseconds: 300),
      );
    }
    // 3b) حذف
    else if (newTodos.length < old.length) {
      // نجد أي id افتقدناه
      final removed = old.where((t) => !newTodos.contains(t)).toList();
      if (removed.isNotEmpty) {
        final todo = removed.first;
        final index = old.indexOf(todo);
        _items.removeAt(index);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) =>
              _buildItem(widget.controller, todo, animation, context),
          duration: const Duration(milliseconds: 300),
        );
      }
    }
    // (تغييرات أخرى مثل ترتيب أو تعديل لا نتعامل معها هنا)
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          final todo = _items[index];
          return _buildItem(widget.controller, todo, animation, context);
        },
      ),
    );
  }

  // 4) بناء العنصر مع انتقال الحجم والشفافية
  Widget _buildItem(
    TodoController controller,
    Todo todo,
    Animation<double> anim,
    BuildContext ctx,
  ) {
    // تاريخ منسّق
    final formatted = todo.dueDate != null
        ? DateFormat('yyyy‑MM‑dd • HH:mm').format(todo.dueDate!)
        : '';
    return SizeTransition(
      sizeFactor: anim, // يكبر من 0→1 في الدخول
      axisAlignment: -1,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: GestureDetector(
            onTap: () => widget.controller.toggleDone(todo.id),
            child:
                // استخدام Obx لتحديث الأيقونة عند تغيير الحالة
                Icon(
                  todo.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: todo.done
                      ? Theme.of(ctx).colorScheme.primary
                      : Theme.of(ctx).colorScheme.onSurfaceVariant,
                ),
          ),
          title: Text(todo.title, style: Theme.of(ctx).textTheme.bodyMedium),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description.isNotEmpty) Text(todo.description),
              if (formatted.isNotEmpty)
                Text(
                  formatted,
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              // الزر يحذف مع الرسوم
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // هنا نستدعي حذف الكونترولر، وسيتم اعتراضه في listener
                  widget.controller.deleteWithUndo(todo);
                },
              ),
            ],
          ),
          onTap: () =>
              Get.toNamed('/add-edit', arguments: todo), // مسار Add/Edit
        ),
      ),
    );
  }
}
