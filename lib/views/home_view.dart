import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'package:todo_app_getx/routes/app_routes.dart';
import 'package:todo_app_getx/views/widgets/filter_todo_widget.dart';
import 'package:todo_app_getx/views/widgets/todo_animated_listview.dart';
import 'widgets/category_count_widget.dart';
import 'widgets/search_widget.dart';

class HomeView extends GetView<TodoController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // لإغلاق لوحة المفاتيح عند النقر في أي مكان
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text('قائمة المهام'.tr),
          actions: [
            // زر الإعدادات
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.SETTINGS),
              icon: const Icon(Icons.settings),
            ),
            // زر تغيير الوضع المظلم
            IconButton(
              onPressed: () => Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              ),
              icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
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
            TodoAnimatedListView(controller: controller),
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

/// ويدجت لبناء بطاقة فئة واحدة
// Widget _buildCategoryCard(String cat, int count , TodoController controller) {
//   return Card(
//     color: _categoryColors[cat],
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     child: SizedBox(
//       width: 100,
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(_categoryIcons[cat], size: 28, color: Colors.black54),
//             const SizedBox(height: 6),
//             Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text('$count', style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     ),
//   );
// }
