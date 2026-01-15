/// Model för en enskild ToDo-uppgift
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  const Todo({required this.id, required this.title, this.isCompleted = false});

  /// CopyWith för att skapa en ny Todo med uppdaterade värden
  Todo copyWith({String? id, String? title, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// State för TodoCubit
class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  const TodoState({this.todos = const [], this.isLoading = false, this.error});

  TodoState copyWith({List<Todo>? todos, bool? isLoading, String? error}) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Antal slutförda todos
  int get completedCount => todos.where((todo) => todo.isCompleted).length;

  /// Antal kvarstående todos
  int get remainingCount => todos.length - completedCount;

  @override
  String toString() =>
      'TodoState(todos: ${todos.length}, isLoading: $isLoading, error: $error)';
}
