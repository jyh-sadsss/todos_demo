import 'package:flutter/material.dart';
import 'package:todo_demo/model/todos_option.dart';

class TodosOptionButton extends StatelessWidget {
  final Function(TodosOption) onSelected;
  const TodosOptionButton({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: onSelected,
        itemBuilder: (context) {
          return const [
            // 里面的const可以提到外面来
            PopupMenuItem<TodosOption>(
                value: TodosOption.markAllAsCompleted, child: Text('标记全部完成')),
            PopupMenuItem<TodosOption>(
                value: TodosOption.clearCompleted, child: Text('清除已完成')),
          ];
        });
  }
}
