import 'package:flutter/material.dart';
import 'package:todo_demo/model/todo.dart';

// 纯展示组件
class TodoListTile extends StatelessWidget {
  final Todo todo;
  // 添加一个点击回调
  final VoidCallback onTap;
  // 添加一个勾选方法
  final Function(bool) onChanged;

  const TodoListTile(
      {super.key,
      required this.todo,
      required this.onTap,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (value) {
          // 点击完成
          if (value != null) {
            onChanged.call(value);
          }
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(todo.description),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
