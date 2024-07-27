import 'package:flutter/material.dart';
import 'package:todo_demo/model/todo.dart';
import 'package:todo_demo/repository/local_respository.dart';
import 'package:uuid/uuid.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo? todo;

  const EditTodoScreen({super.key, this.todo}); // 定义一个screen，有一个todo参数

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  String? _title;
  String? _description;

  // todo 传进来赋值
  @override
  void initState() {
    super.initState();

    final todo = widget.todo;
    _title = todo?.title;
    _description = todo?.description;
  }

  void _addTodo() {
    final todosApi = LocalRespository();
    final id = const Uuid().v4();
    final newTodo = Todo(
        // Todo()：实例化一个Todo对象
        id: id,
        title: _title!,
        description: _description ?? '');
    todosApi.add(newTodo); // _title! 非空断言
    // 返回到上一页
    Navigator.pop(context, newTodo); // 将newTodo返回到上一页
  }

  void _updateTodo() {
    final todo = widget.todo;
    if (todo == null) return;
    final todosApi = LocalRespository();
    final newTodo =
        todo.copyWith(title: _title, description: _description ?? '');
    todosApi.update(newTodo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Scaffold(
        appBar: AppBar(title: Text(todo == null ? '添加任务' : '编辑任务')),
        floatingActionButton: FloatingActionButton(
          onPressed: _title != null
              ? () {
                  // 判断添加任务还是编辑任务
                  todo == null ? _addTodo() : _updateTodo();
                }
              : null,
          child: const Icon(Icons.done),
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15), // 仅设置左右边距，也可以设置上下边距
            child: Column(
              children: [
                _TitleField(
                  initialValue: _title,
                  hintText: todo?.title ?? '请输入任务名称',
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                ),
                _DescriptionField(
                  initialValue: _description,
                  hintText: todo?.description ?? '请输入任务描述',
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                )
              ],
            )));
  }
}

// 输入框组件
class _TitleField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final Function(String?)? onChanged;

  const _TitleField(
      { // 加上{} 易读
      this.initialValue,
      this.hintText,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: 50,
      maxLines: 1, // 不换行
      decoration: InputDecoration(
        label: const Text("任务名称"),
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final Function(String?)? onChanged;

  const _DescriptionField(
      { // 加上{} 易读
      this.initialValue,
      this.hintText,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: 300,
      maxLines: 5, // 不换行
      decoration: InputDecoration(
        label: const Text("描述"),
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}
