import 'package:flutter/material.dart';
import 'package:todo_demo/model/todo.dart';

// 纯展示组件
class TodoListTile extends StatelessWidget {
  final Key itemKey;
  final Todo todo;
  // 添加一个点击回调
  final VoidCallback onTap;
  // 添加一个删除回调
  final VoidCallback onDelete;
  // 添加一个勾选方法
  final Function(bool) onChanged;

  const TodoListTile(
      {super.key,
      required this.itemKey,
      required this.todo,
      required this.onTap,
      required this.onDelete,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // 抽屉组件，左滑可以点击删除
    return Dismissible(
        key: itemKey,
        background: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ListTile(
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
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(todo.description),
          trailing: const Icon(Icons.arrow_forward_ios),
        ));
  }
}
