import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/controllers/todo_controller.dart';
import 'todo_listview_card_widget.dart';

class TodoListView extends StatelessWidget {
  final TodoController controller;
  const TodoListView({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final list = controller.filteredTodos;
        if (list.isEmpty) {
          return const Center(child: Text('لا توجد مهام'));
        }
        if (controller.filterStatus.value == FilterStatus.all &&
            controller.searchQuery.value.isEmpty) {
          return ReorderableListView.builder(
            onReorder: controller.reorderTodos,
            itemCount: list.length,
            itemBuilder: (context, i) => TodoListviewCardWidget(
              controller: controller,
              todo: list[i],
              context: context,
            ),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => TodoListviewCardWidget(
            controller: controller,
            todo: list[i],
            context: context,
          ),
        );
      }),
    );
  }
}
