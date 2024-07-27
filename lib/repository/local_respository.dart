import 'package:todo_demo/model/todo.dart';
import 'package:todo_demo/repository/todos_api.dart';

typedef TodosChangedListener = Function(List<Todo>);

// 实现接口
class LocalRespository extends TodosApi {
  static final _instance = LocalRespository._(); // 私有构造函数：_()  静态实例常量：_instance
  LocalRespository._(); // 这行表示必须在内部显式调用一次，以确保编译器能够正确处理私有成员
  factory LocalRespository() =>
      _instance; // 每次调用LocalRespository()都会返回_instance，保证全局只有一个实例

  final List<Todo> _todos = [];
  final List<TodosChangedListener> _todosChangedListeners = [];

  @override
  Future<bool> add(Todo todo) async {
    _todos.add(todo);
    notifyTodosChanged();
    return Future.value(true);
  }

  Future<bool> update(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) {
      return false;
    }
    _todos.removeWhere((e) => e.id == todo.id);
    if (index > _todos.length - 1) {
      // 添加
      _todos.add(todo);
    } else {
      _todos.insert(index, todo);
    }
    notifyTodosChanged();
    return Future.value(true);
  }

  @override
  Future<bool> clearCompleted() async {
    _todos.removeWhere((todo) => todo.isCompleted);
    notifyTodosChanged();
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyTodosChanged();
    return Future.value(true);
  }

  @override
  Future<List<Todo>> getTodos() async {
    return _todos;
  }

  @override
  Future<bool> markAllAsCompleted() {
    final newTodos = _todos.map((e) => e.copyWith(isCompleted: true)).toList();
    _todos.clear();
    _todos.addAll(newTodos); // 将一个列表的所有元素添加到当前列表的末尾
    notifyTodosChanged();
    return Future.value(true);
  }

  void notifyTodosChanged() {
    // 发布订阅模式
    for (final listener in _todosChangedListeners) {
      listener(_todos);
    }
  }

  void addTodoChangedListener(TodosChangedListener listener) {
    _todosChangedListeners.add(listener);
  }

  // 添加之后需要在生命周期函数内销毁
  void removeTodoChangedListener(TodosChangedListener listener) {
    _todosChangedListeners.remove(listener);
  }
}
