import 'package:flutter/material.dart';
import 'package:todo_demo/model/todo.dart';
import 'package:todo_demo/repository/local_respository.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _StatusScreenState();
  }
}

class _StatusScreenState extends State<StatusScreen> {
  int _activeTodosCount = 0;
  int _completedTodosCount = 0;
  TodosChangedListener? _todosChangedListener;

  final _todosApi = LocalRespository();

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  void _getTodos() async {
    List<Todo> todos = await _todosApi.getTodos();
    // setState(() {
    //   _activeTodosCount = todos.where((todo) => !todo.isCompleted).length;
    //   _completedTodosCount = todos.where((todo) => todo.isCompleted).length;
    // });
    _todosChangedListener = (todos) {
      // setState(() {
      //   todos.clear();
      //   todos.addAll(todos);
      // });
      setState(() {
        // setState不能滥用，上面这种方法错误是，todos更新之后，并没有更新_activeTodosCount和_completedTodosCount
        _activeTodosCount = todos.where((todo) => !todo.isCompleted).length;
        _completedTodosCount = todos.where((todo) => todo.isCompleted).length;
      });
    };
    // 添加监听器
    _todosApi.addTodoChangedListener(_todosChangedListener!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("统计"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _StatusItem(
              icon: const Icon(Icons.done),
              title: "已完成任务",
              value: _completedTodosCount),
          _StatusItem(
              icon: const Icon(Icons.circle),
              title: "激活中任务",
              value: _activeTodosCount)
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_todosChangedListener != null) {
      _todosApi.removeTodoChangedListener(_todosChangedListener!);
      _todosChangedListener = null;
    }
    super.dispose();
  }
}

class _StatusItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final int value;
  const _StatusItem(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // 单个组件
        height: 50,
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ), // 左侧占位
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(title),
            const Spacer(), // 占满中间的位置
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 15,
            ), // 右侧占位
          ],
        ));
  }
}
