import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class AddEditView extends GetView<TodoController> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final todo = Get.arguments; // الحصول على البيانات المرسلة من الشاشة السابقة
    if (todo != null) {
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
    }
    return Scaffold(
      appBar: AppBar(title: Text(todo == null ? 'إضافة مهمة' : 'تعديل مهمة')),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'العنوان'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'الوصف'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (todo == null) {
                  controller.addTodo(
                    _titleController.text,
                    _descriptionController.text,
                  );
                  // هنا يمكنك الحصول على العنوان والوصف من TextField
                } else {
                  controller.updateTodo(
                    todo.id,
                    _titleController.text,
                    _descriptionController.text,
                  );
                  // هنا يمكنك الحصول على العنوان والوصف من TextField
                }
                Get.back(); // العودة إلى الشاشة السابقة
              },
              child: Text(todo == null ? 'إضافة' : 'تعديل'),
            ),
          ],
        ),
      ),
    );
  }
}
