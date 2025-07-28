import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/routes/app_routes.dart';

class HomeView extends GetView<TodoController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(
        context,
      ).unfocus(), // لإغلاق لوحة المفاتيح عند النقر في أي مكان
      child: Scaffold(
        appBar: AppBar(title: Text('قائمة المهام')),
        body: Column(
          children: [
            // ——— شريط البحث ———
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: controller.searchQuery,
                decoration: InputDecoration(
                  // labelText: 'بحث عن مهمة',
                  hintText: 'ابحث عن مهمة...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // ——— أزرار الفلترة ———
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: FilterStatus.values.map((status) {
                  final label = {
                    FilterStatus.all: 'الكل',
                    FilterStatus.completed: 'مكتملة',
                    FilterStatus.incomplete: 'غير مكتملة',
                  }[status]!;
                  final selected = controller.filterStatus.value == status;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => controller.filterStatus(status),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 12),
            // ——— القائمة مع دعم السحب لإعادة الترتيب ———
            Expanded(
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
                              onChanged: (value) =>
                                  controller.toggleDone(todo.id),
                            ),
                            // --- زر الحذف ---
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Get.defaultDialog: طريقة GetX لعرض مربع حوار بسرعة
                                Get.defaultDialog(
                                  title: 'تأكيد الحذف',
                                  middleText:
                                      'هل أنت متأكد أنك تريد حذف هذه المهمة؟',
                                  textConfirm: 'حذف',
                                  textCancel: 'إلغاء',
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    controller.deleteTodo(todo.id);
                                    Get.back(); // إغلاق مربع الحوار
                                  },
                                  onCancel: () =>
                                      Get.back(), // إغلاق مربع الحوار
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () =>
                            Get.toNamed(AppRoutes.ADD_EDIT, arguments: todo),
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
                      onTap: () =>
                          Get.toNamed(AppRoutes.ADD_EDIT, arguments: todo),
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.ADD_EDIT),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
