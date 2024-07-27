import 'package:flutter/material.dart';
import 'package:todo_demo/model/todo.dart';
import 'package:todo_demo/model/todos_filter_option.dart';
import 'package:todo_demo/model/todos_option.dart';
import 'package:todo_demo/repository/local_respository.dart';
import 'package:todo_demo/screen/todo_edit_screen.dart';
import 'package:todo_demo/widget/todo_list_tile.dart';
import 'package:todo_demo/widget/todos_filter_button.dart';
import 'package:todo_demo/widget/todos_option_button.dart';

class TodosScreen extends StatefulWidget {
  // 有状态的widget
  const TodosScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodosScreenState();
  }
}

class _TodosScreenState extends State<TodosScreen> {
  final List<Todo> _todos = [];
  final todosApi = LocalRespository();
  TodosFilterOption _filterOption = TodosFilterOption.all;

  // 创建一个监听器，定义未赋值
  TodosChangedListener? _todosChangedListener;

  @override
  void initState() {
    // 调用父类initState方法，确保父类initState方法在之前已经完毕
    super.initState();
    _init();
  }

  void _init() async {
    final todos = await todosApi.getTodos();
    setState(() {
      _todos.addAll(todos);
    });
    _todosChangedListener = (todos) {
      setState(() {
        _todos.clear();
        _todos.addAll(todos);
      });
    };
    // 添加监听器
    todosApi.addTodoChangedListener(_todosChangedListener!);
  }

  // 定义一个过滤方法
  List<Todo> _filterTodos(List<Todo> todos) {
    switch (_filterOption) {
      case TodosFilterOption.all:
        return todos;
      case TodosFilterOption.completed:
        return todos
            .where((todo) => todo.isCompleted)
            .toList(); // Iterator集合，需要转换成List
      case TodosFilterOption.active:
        return todos.where((todo) => !todo.isCompleted).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = _filterTodos(_todos);
    return Scaffold(
        appBar: AppBar(
            title: const Text('任务列表'),
            backgroundColor: Colors.blue,
            actions: [
              TodosFilterButton(
                selectedFilterOption: _filterOption,
                onSelected: (value) {
                  setState(() {
                    _filterOption = value;
                  });
                },
              ),
              TodosOptionButton(
                onSelected: _onOptionSelected,
              )
            ]),
        body: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index]; // 下标
              return TodoListTile(
                  todo: todo,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return EditTodoScreen(todo: todo);
                      },
                    ));
                  },
                  onChanged: (value) {
                    _updateTodoCompletedStatus(todo, value);
                  });
            }));
  }

  void _onOptionSelected(TodosOption option) {
    if (option == TodosOption.clearCompleted) {
      todosApi.clearCompleted();
    } else if (option == TodosOption.markAllAsCompleted) {
      todosApi.markAllAsCompleted();
    }
  }

  // 定义一个更新方法
  void _updateTodoCompletedStatus(Todo todo, bool isCompleted) {
    final newTodo = todo.copyWith(isCompleted: isCompleted);
    todosApi.update(newTodo);
  }

  @override
  void dispose() {
    // 移除监听器
    todosApi.removeTodoChangedListener(_todosChangedListener!);
    super.dispose();
  }
}
