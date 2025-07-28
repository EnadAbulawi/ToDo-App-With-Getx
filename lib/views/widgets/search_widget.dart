import 'package:flutter/material.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.controller});

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: controller.searchQuery,
        decoration: InputDecoration(
          // labelText: 'بحث عن مهمة',
          hintText: 'ابحث عن مهمة...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
