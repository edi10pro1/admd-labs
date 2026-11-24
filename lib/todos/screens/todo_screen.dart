import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab1_app/models/todo.dart';
import 'package:lab1_app/todos/bloc/todo_bloc.dart';
import 'package:lab1_app/todos/bloc/todo_event.dart';
import 'package:lab1_app/todos/bloc/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

// Stateful doar pentru TextEditingController (nu există setState).
class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _input = TextEditingController();

  void _add() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    context.read<TodoBloc>().add(AddTodo(text));
    _input.clear();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List (Lab 5)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: const InputDecoration(labelText: 'New todo'),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _add),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];

                          return Dismissible(
                            key: ValueKey(todo.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: const Icon(Icons.delete,
                                  color: Colors.white),
                            ),
                            onDismissed: (_) {
                              final bloc = context.read<TodoBloc>();
                              bloc.add(RemoveTodo(todo.id));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sters "${todo.title}"'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () =>
                                        bloc.add(RestoreTodo(index, todo)),
                                  ),
                                ),
                              );
                            },
                            child: TodoTile(
                              todo: todo,
                              onChanged: (_) => context
                                  .read<TodoBloc>()
                                  .add(ToggleTodo(todo.id)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoTile({super.key, required this.todo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        title: Text(todo.title),
        trailing: Checkbox(value: todo.completed, onChanged: onChanged),
      ),
    );
  }
}