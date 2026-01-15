import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_state.dart';

/// TodoCubit - Hanterar en lista av todos
///
/// Demonstrerar:
/// - List manipulation i state
/// - Async operations med delay
/// - CRUD operations (Create, Read, Update, Delete)
class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  /// Lägg till en ny todo (synkront)
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    // Skapa ny lista med den nya todon
    final updatedTodos = [...state.todos, newTodo];
    emit(state.copyWith(todos: updatedTodos));
  }

  /// Lägg till todo async med 2 sek delay (simulerar API-call)
  Future<void> addTodoAsync(String title) async {
    if (title.trim().isEmpty) return;

    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Simulera API-call
      await Future.delayed(const Duration(seconds: 2));

      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
      );

      final updatedTodos = [...state.todos, newTodo];
      emit(state.copyWith(todos: updatedTodos, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to add todo: $e'));
    }
  }

  /// Toggle completed status för en todo
  void toggleTodo(String id) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  /// Ta bort en todo
  void removeTodo(String id) {
    final updatedTodos = state.todos.where((todo) => todo.id != id).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  /// Ta bort alla completed todos
  void clearCompleted() {
    final updatedTodos = state.todos
        .where((todo) => !todo.isCompleted)
        .toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  /// Rensa alla todos
  void clearAll() {
    emit(const TodoState());
  }

  /// Lägg till några exempel-todos (för demo)
  void loadDemoData() {
    final demoTodos = [
      const Todo(id: '1', title: 'Lär dig Flutter'),
      const Todo(id: '2', title: 'Förstå Bloc & Cubit', isCompleted: true),
      const Todo(id: '3', title: 'Bygg en cool app'),
    ];

    emit(state.copyWith(todos: demoTodos));
  }
}
