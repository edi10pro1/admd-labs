import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1_app/todos/bloc/todo_bloc.dart';
import 'package:lab1_app/todos/bloc/todo_event.dart';
import 'package:lab1_app/todos/screens/todo_screen.dart';
import 'package:lab1_app/todos/todo_repository.dart';

void main() => runApp(BlocProvider(
      create: (_) => TodoBloc(TodoRepository(Dio()))..add(LoadTodos()),
      child: const TodoApp(),
    ));

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TodoScreen());
  }
}