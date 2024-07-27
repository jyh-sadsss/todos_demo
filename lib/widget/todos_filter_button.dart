import 'package:flutter/material.dart';
import 'package:todo_demo/model/todos_filter_option.dart';

class TodosFilterButton extends StatelessWidget {
  // 定义一个选中状态
  final TodosFilterOption selectedFilterOption;
  final Function(TodosFilterOption) onSelected;
  const TodosFilterButton(
      {super.key,
      required this.selectedFilterOption,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        initialValue: selectedFilterOption,
        onSelected: onSelected,
        itemBuilder: (context) {
          return const [
            // 里面的const可以提到外面来
            PopupMenuItem<TodosFilterOption>(
                value: TodosFilterOption.all, child: Text('所有')),
            PopupMenuItem<TodosFilterOption>(
                value: TodosFilterOption.active, child: Text('已激活')),
            PopupMenuItem<TodosFilterOption>(
                value: TodosFilterOption.completed, child: Text('已完成'))
          ];
        },
        child: const Icon(Icons.filter_list_rounded));
  }
}
