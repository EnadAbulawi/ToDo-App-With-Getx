import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class FilterTodoWidget extends StatelessWidget {
  const FilterTodoWidget({super.key, required this.controller});

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
    });
  }
}
