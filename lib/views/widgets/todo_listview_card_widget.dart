import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/models/todo.dart';
import 'package:todo_app_getx/routes/app_routes.dart';

class TodoListviewCardWidget extends StatefulWidget {
  const TodoListviewCardWidget({
    super.key,
    required this.controller,
    required this.todo,
    required this.context,
  });

  final TodoController controller;
  final Todo todo;
  final BuildContext context;

  @override
  State<TodoListviewCardWidget> createState() => _TodoListviewCardWidgetState();
}

class _TodoListviewCardWidgetState extends State<TodoListviewCardWidget> {
  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.todo.dueDate != null
        ? DateFormat('yyyy‑MM‑dd • HH:mm').format(widget.todo.dueDate!)
        : null;
    return Card(
      key: ValueKey(widget.todo.id),
      color: widget.controller.categoryColor[widget.todo.category]!,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: GestureDetector(
          onTap: () => widget.controller.toggleDone(widget.todo.id),
          child: Icon(
            widget.todo.done
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: widget.todo.done
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          widget.todo.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.todo.description.isNotEmpty)
              Text(widget.todo.description),
            if (formattedDate != null)
              Text(
                formattedDate,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => Get.defaultDialog(
            title: 'تأكيد الحذف'.tr,
            middleText: 'هل تريد حذف هذه المهمة؟'.tr,
            textConfirm: 'حذف'.tr,
            textCancel: 'إلغاء'.tr,
            confirmTextColor: Colors.white,
            onConfirm: () {
              widget.controller.deleteTodo(widget.todo.id);
              Get.back();
            },
          ),
        ),
        onTap: () => Get.toNamed(AppRoutes.ADD_EDIT, arguments: widget.todo),
      ),
    );
  }
}
