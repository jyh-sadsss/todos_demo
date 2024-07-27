import 'package:todo_demo/model/todo.dart';

// 定义接口
abstract class TodosApi {
  Future<bool> add(Todo todo);
  Future<bool> delete(String id);
  Future<bool> markAllAsCompleted();
  Future<bool> clearCompleted();
  Future<List<Todo>> getTodos();
}
