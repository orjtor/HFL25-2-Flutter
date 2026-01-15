import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v07_cubit/features/todo/cubit/todo_cubit.dart';
import 'package:v07_cubit/features/todo/cubit/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo(BuildContext context, {bool async = false}) {
    final title = _controller.text;
    if (title.trim().isEmpty) return;

    if (async) {
      context.read<TodoCubit>().addTodoAsync(title);
    } else {
      context.read<TodoCubit>().addTodo(title);
    }

    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List - Labb 2'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              final cubit = context.read<TodoCubit>();
              switch (value) {
                case 'demo':
                  cubit.loadDemoData();
                  break;
                case 'clearCompleted':
                  cubit.clearCompleted();
                  break;
                case 'clearAll':
                  cubit.clearAll();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'demo',
                child: Text('Ladda demo-data'),
              ),
              const PopupMenuItem(
                value: 'clearCompleted',
                child: Text('Rensa completed'),
              ),
              const PopupMenuItem(value: 'clearAll', child: Text('Rensa alla')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return Column(
            children: [
              // Error message
              if (state.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.shade100,
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Loading indicator
              if (state.isLoading)
                const LinearProgressIndicator()
              else
                const SizedBox(height: 4),

              // Input field
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Lägg till en todo...',
                          border: OutlineInputBorder(),
                        ),
                        enabled: !state.isLoading,
                        onSubmitted: (_) => _addTodo(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: state.isLoading
                          ? null
                          : () => _addTodo(context),
                      tooltip: 'Lägg till (direkt)',
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_alarm),
                      onPressed: state.isLoading
                          ? null
                          : () => _addTodo(context, async: true),
                      tooltip: 'Lägg till (async 2 sek)',
                    ),
                  ],
                ),
              ),

              // Stats
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.grey.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Total: ${state.todos.length}'),
                    Text('Kvarstående: ${state.remainingCount}'),
                    Text('Klara: ${state.completedCount}'),
                  ],
                ),
              ),

              // Todo list
              Expanded(
                child: state.todos.isEmpty
                    ? const Center(
                        child: Text(
                          'Inga todos ännu!\nLägg till en eller tryck på menyn för demo-data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];
                          return Dismissible(
                            key: Key(todo.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              context.read<TodoCubit>().removeTodo(todo.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('"${todo.title}" borttagen'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: Checkbox(
                                value: todo.isCompleted,
                                onChanged: (_) {
                                  context.read<TodoCubit>().toggleTodo(todo.id);
                                },
                              ),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: todo.isCompleted ? Colors.grey : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  context.read<TodoCubit>().removeTodo(todo.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
