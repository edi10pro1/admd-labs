import 'package:lab1_app/models/todo.dart';

sealed class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  AddTodo(this.title);
  final String title;
}

class ToggleTodo extends TodoEvent {
  ToggleTodo(this.id);
  final int id;
}

class RemoveTodo extends TodoEvent {
  RemoveTodo(this.id);
  final int id;
}

// pentru UNDO
class RestoreTodo extends TodoEvent {
  RestoreTodo(this.index, this.todo);
  final int index;
  final Todo todo;
}