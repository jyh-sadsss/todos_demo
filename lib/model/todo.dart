class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  // 补全说明
  const Todo(
      {required this.id,
      required this.title,
      required this.description,
      this.isCompleted = false});
  // 定义一个方法
  Todo copyWith(
      {String? id, String? title, String? description, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
