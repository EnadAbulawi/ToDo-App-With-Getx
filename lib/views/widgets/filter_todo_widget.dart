import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';

class FilterTodoWidget extends StatelessWidget {
  final TodoController controller;
  const FilterTodoWidget({required this.controller, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 12,
        alignment: WrapAlignment.center,
        children: FilterStatus.values.map((status) {
          final labels = {
            FilterStatus.all: 'الكل',
            FilterStatus.completed: 'المكتملة',
            FilterStatus.incomplete: 'غير المكتملة',
          };
          final selected = controller.filterStatus.value == status;
          return ChoiceChip(
            label: Text(labels[status]!),
            selected: selected,
            onSelected: (_) => controller.filterStatus(status),
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          );
        }).toList(),
      );
    });
  }
}
