import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1_app/models/todo.dart';
import 'package:lab1_app/todos/todo_repository.dart';
import 'package:lab1_app/todos/bloc/todo_event.dart';
import 'package:lab1_app/todos/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._repo) : super(const TodoState()) {
    on<LoadTodos>(_onLoad);
    on<AddTodo>(_onAdd);
    on<ToggleTodo>(_onToggle);
    on<RemoveTodo>(_onRemove);
    on<RestoreTodo>(_onRestore);
  }

  final TodoRepository _repo;

  Future<void> _onLoad(LoadTodos e, Emitter<TodoState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      emit(TodoState(todos: await _repo.fetchTodos()));
    } catch (_) {
      emit(TodoState(
        todos: state.todos,
        error: 'couldnt load todos.',
      ));
    }
  }

  void _onAdd(AddTodo e, Emitter<TodoState> emit) {
    final nextId = state.todos.isEmpty
        ? 1
        : state.todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    emit(state.copyWith(todos: [
      ...state.todos,
      Todo(userId: 1, id: nextId, title: e.title, completed: false),
    ]));
  }

  void _onToggle(ToggleTodo e, Emitter<TodoState> emit) {
    emit(state.copyWith(todos: [
      for (final t in state.todos)
        if (t.id == e.id) t.copyWith(completed: !t.completed) else t,
    ]));
  }

  void _onRemove(RemoveTodo e, Emitter<TodoState> emit) {
    emit(state.copyWith(
      todos: state.todos.where((t) => t.id != e.id).toList(),
    ));
  }

  void _onRestore(RestoreTodo e, Emitter<TodoState> emit) {
    final list = [...state.todos];
    list.insert(e.index.clamp(0, list.length), e.todo);
    emit(state.copyWith(todos: list));
  }
}