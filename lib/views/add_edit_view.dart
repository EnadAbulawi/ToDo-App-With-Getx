import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/models/todo.dart';

class AddEditView extends GetView<TodoController> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _pickedDate; // ← يخزن التاريخ الذي يختاره المستخدم
  TimeOfDay? _pickedTime; // ← يخزن الوقت
  String _selectedCategory = 'عام'; // ← يخزن الفئة المختارة
  final List<String> _categories = [
    'عام'.tr,
    'عمل'.tr,
    'دراسة'.tr,
    'شخصي'.tr,
  ]; // ← قائمة الفئات
  Priority _selectedPriority = Priority.low; // ← يخزن الأولوية المختارة

  @override
  Widget build(BuildContext context) {
    final todo = Get.arguments; // الحصول على البيانات المرسلة من الشاشة السابقة
    if (todo != null) {
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
      _pickedDate = todo.dueDate; // تعيين التاريخ إذا كان موجودًا
      _selectedCategory = todo.category;
      _selectedPriority = todo.priority;
      if (_pickedDate != null) {
        _pickedTime = TimeOfDay.fromDateTime(
          _pickedDate!,
        ); // تعيين الوقت من التاريخ
      }
    }

    // دالة مساعدة لجمع التاريخ والوقت في DateTime واحد
    DateTime? getSelectedsDateTime() {
      if (_pickedTime == null || _pickedDate == null) return null;
      return DateTime(
        _pickedDate!.year,
        _pickedDate!.month,
        _pickedDate!.day,
        _pickedTime!.hour,
        _pickedTime!.minute,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null ? 'إضافة مهمة'.tr : 'تعديل مهمة'.tr),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'task_title'.tr),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'task_description'.tr),
            ),
            SizedBox(height: 20),
            // زر اختيار التاريخ
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _pickedDate == null
                    ? 'due_date'.tr
                    : '${_pickedDate!.year}/${_pickedDate!.month}/${_pickedDate!.day}',
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _pickedDate ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 0)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) _pickedDate = date;
              },
            ),

            // زر اختيار الوقت
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(
                _pickedTime == null
                    ? 'due_time'.tr
                    : _pickedTime!.format(context),
              ),
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _pickedTime ?? TimeOfDay.now(),
                );
                if (time != null) _pickedTime = time;
              },
            ),
            ElevatedButton(
              onPressed: () {
                final due =
                    getSelectedsDateTime(); // الحصول على التاريخ والوقت المختارين
                if (todo == null) {
                  controller.addTodo(
                    _titleController.text,
                    _descriptionController.text,
                    due,
                    _selectedCategory,
                    _selectedPriority,
                  );
                  // هنا يمكنك الحصول على العنوان والوصف من TextField
                } else {
                  controller.updateTodo(
                    todo.id,
                    _titleController.text,
                    _descriptionController.text,
                    due,
                    _selectedCategory,
                    _selectedPriority,
                  );
                  // هنا يمكنك الحصول على العنوان والوصف من TextField
                }
                Get.back(); // العودة إلى الشاشة السابقة
              },
              child: Text(todo == null ? 'add_task'.tr : 'تعديل'.tr),
            ),

            SizedBox(height: 20),
            // اختيار الفئة
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              decoration: InputDecoration(labelText: 'الفئة'.tr),
              onChanged: (v) => _selectedCategory = v!,
            ),
            SizedBox(height: 20),
            // اختيار الأولوية
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              items: Priority.values.map((p) {
                final label = {
                  Priority.low: 'منخفضة'.tr,
                  Priority.medium: 'متوسطة'.tr,
                  Priority.high: 'مرتفعة'.tr,
                };
                return DropdownMenuItem(
                  value: p,
                  child: Text(label[p] ?? 'غير محددة'.tr),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'الأولوية'.tr),
              onChanged: (v) => _selectedPriority = v!,
            ),
          ],
        ),
      ),
    );
  }
}
