import 'package:flutter/material.dart';

import '../models/todo.dart'; 
import '../api/todo_api.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  final List<Todo> _items = [];

  final TextEditingController _input = TextEditingController();
  final _todoApi = TodoApi();

  String? _errorMessage;


@override
  void initState() {
    super.initState();
    _loadTodos(); 
  }

  Future<void> _loadTodos() async {
    try {

      final fetchedTodos = await _todoApi.withRetry(() => _todoApi.fetchTodos());
      setState(() {
        _items.clear();
        _items.addAll(fetchedTodos);
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = _todoApi.errors; 
      });
      
      print('error loading todos: $e');
    }
  }
 
  void _add() {
    if (_input.text.trim().isEmpty) return;
    setState(() {
     _items.add(Todo(
        userId: 1, 
        id: _items.length + 1, 
        title: _input.text, 
        completed: false,
      ));
    });
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
      appBar: AppBar(title: const Text('To-Do List (Lab 4)')),
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
            
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _add, 
                ),
              ],
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final todo = _items[index];

                return Dismissible(
                  key: ValueKey(todo.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    final deletedTodo = todo;
                    final deletedIndex = index;

                    setState(() {
                      _items.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sters "${deletedTodo.title}"'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            setState(() {
                              _items.insert(deletedIndex, deletedTodo);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: TodoTile(
                    todo: todo,
                    onChanged: (val) {
                      setState(() {
                        // Notă: Deoarece obiectul Todo generat de json_serializable e imutabil (final),
                        // pentru toggle creăm o instanță nouă sau tratăm starea local. 
                        // Momentan actualizăm starea sau recreăm obiectul copiat.
                      });
                    },
                  ),
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
        trailing: Checkbox(
          value: todo.completed, // Folosim completed conform modelului nou
          onChanged: onChanged,
        ),
      ),
    );
  }
}