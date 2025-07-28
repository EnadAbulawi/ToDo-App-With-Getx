import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/routes/app_routes.dart';
import 'package:todo_app_getx/views/widgets/filter_todo_widget.dart';

import 'widgets/category_count_widget.dart';
import 'widgets/search_widget.dart';
import 'widgets/todo_listview.dart';

class HomeView extends GetView<TodoController> {
  const HomeView({super.key});

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
            // —— ملخص الفئات مع عدد المهام ——
            CategoryCountWidget(controller: controller),
            // ——— شريط البحث ———
            SearchWidget(controller: controller),
            // ——— أزرار الفلترة ———
            FilterTodoWidget(controller: controller),
            const SizedBox(height: 12),
            // ——— القائمة مع دعم السحب لإعادة الترتيب ———
            TodoListview(controller: controller),
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
