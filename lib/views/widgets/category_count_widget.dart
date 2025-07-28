import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class CategoryCountWidget extends StatelessWidget {
  const CategoryCountWidget({super.key, required this.controller});

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: controller.categories.length,
        itemBuilder: (_, i) {
          final cat = controller.categories[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Container(
              width: 145,
              height: 100,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFFB4C4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 17,
                    child: Icon(Icons.person, size: 20, color: Colors.black),
                  ),

                  const SizedBox(height: 8),
                  // ——— أزرار الفلترة ———
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // هنا يمكن إضافة أيقونة أو زر آخر إذا لزم الأمر
                      // IconButton(
                      //   icon: const Icon(Icons.add),
                      //   onPressed: () {
                      //     Get.toNamed(
                      //       AppRoutes.ADD_EDIT,
                      //       arguments: {'category': cat},
                      //     );
                      //   },
                      // ),
                      Text(
                        cat,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Obx(() {
                        final count = controller.categoryCounts[cat] ?? 0;
                        return Text(
                          '$count مهمة',
                          style: const TextStyle(fontSize: 16),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
