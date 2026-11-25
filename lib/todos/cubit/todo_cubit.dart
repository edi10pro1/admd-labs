import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1_app/models/todo.dart';
import 'package:lab1_app/todos/cubit/todo_state.dart';
import 'package:lab1_app/todos/todo_repository.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repo) : super(const TodoState());

  final TodoRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      emit(TodoState(todos: await _repo.fetchTodos(), loading: false));
    } catch (_) {
      emit(TodoState(todos: state.todos, loading: false));
    }
  }

  void add(String title) {
    final nextId = state.todos.isEmpty
        ? 1
        : state.todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    emit(state.copyWith(todos: [
      ...state.todos,
      Todo(userId: 1, id: nextId, title: title, completed: false),
    ]));
  }

  void toggle(int id) {
    emit(state.copyWith(todos: [
      for (final t in state.todos)
        if (t.id == id) t.copyWith(completed: !t.completed) else t,
    ]));
  }

  void remove(int id) {
    emit(state.copyWith(
      todos: state.todos.where((t) => t.id != id).toList(),
    ));
  }
}