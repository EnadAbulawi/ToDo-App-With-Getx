import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/routes/app_routes.dart';

class TodoListview extends StatelessWidget {
  const TodoListview({super.key, required this.controller});

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        //  إذا كان هناك فلترة أو بحث، نعرض القائمة بدون إعادة ترتيب
        if (controller.filterStatus.value != FilterStatus.all ||
            controller.searchQuery.value.isNotEmpty) {
          final filterd = controller.filteredTodos;
          if (filterd.isEmpty) {
            return Center(child: Text('لا توجد مهام مطابقة'));
          }

          return ListView.builder(
            itemCount: filterd.length,
            itemBuilder: (context, i) {
              final todo = filterd[i];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: Wrap(
                  spacing: 12, // space between icons
                  children: [
                    // --- Checkbox لتغيير حالة الإنجاز ---
                    Checkbox(
                      value: todo.done,
                      onChanged: (value) => controller.toggleDone(todo.id),
                    ),
                    // --- زر الحذف ---
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Get.defaultDialog: طريقة GetX لعرض مربع حوار بسرعة
                        Get.defaultDialog(
                          title: 'تأكيد الحذف',
                          middleText: 'هل أنت متأكد أنك تريد حذف هذه المهمة؟',
                          textConfirm: 'حذف',
                          textCancel: 'إلغاء',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            controller.deleteTodo(todo.id);
                            Get.back(); // إغلاق مربع الحوار
                          },
                          onCancel: () => Get.back(), // إغلاق مربع الحوار
                        );
                      },
                    ),
                  ],
                ),
                onTap: () => Get.toNamed(AppRoutes.ADD_EDIT, arguments: todo),
              );
            },
          );
        }
        // الوضع الافتراضي: كل المهام مع إعادة الترتيب
        final alltodos = controller.todos;
        if (alltodos.isEmpty) {
          return Center(child: Text('لا توجد مهام'));
        }
        return ReorderableListView(
          onReorder: controller.reorderTodos,
          children: alltodos.map((todo) {
            return ListTile(
              key: ValueKey(todo.id),
              title: Text(todo.title),
              subtitle: todo.description.isNotEmpty
                  ? Text(todo.description)
                  : null,
              trailing: Wrap(
                spacing: 12,
                children: [
                  Checkbox(
                    value: todo.done,
                    onChanged: (_) => controller.toggleDone(todo.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'حذف المهمة',
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'تأكيد الحذف',
                        middleText: 'هل أنت متأكد من حذف هذه المهمة؟',
                        textConfirm: 'حذف',
                        textCancel: 'إلغاء',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.deleteTodo(todo.id);
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
              onTap: () => Get.toNamed(AppRoutes.ADD_EDIT, arguments: todo),
            );
          }).toList(),
        );
      }),
    );
  }
}
