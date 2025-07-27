import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/routes/app_routes.dart';

class HomeView extends GetView<TodoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة المهام')),
      body: Obx(() {
        final todos = controller
            .todos; // Assuming you have a list of todos in the controller
        if (todos.isEmpty) {
          return Center(child: Text('لا توجد مهام'));
        }
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, i) {
            final todo = todos[i];
            return ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.description),
              trailing: Checkbox(
                value: todo.done,
                onChanged: (value) => controller.toggleDone(todo.id),
              ),
              onTap: () => Get.toNamed(AppRoutes.ADD_EDIT, arguments: todo),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_EDIT),
        child: Icon(Icons.add),
      ),
    );
  }
}
