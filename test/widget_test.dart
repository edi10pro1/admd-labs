import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lab1_app/main.dart';
import 'package:lab1_app/todos/bloc/todo_bloc.dart';
import 'package:lab1_app/todos/bloc/todo_event.dart';
import 'package:lab1_app/todos/todo_repository.dart';

class FakeTodoRepository extends Mock implements TodoRepository {}

void main() {
  testWidgets('App shows the title', (WidgetTester tester) async {
    final repo = FakeTodoRepository();
    when(() => repo.fetchTodos()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => TodoBloc(repo)..add(LoadTodos()),
        child: const TodoApp(),
      ),
    );
    await tester.pump();

    expect(find.text('to-do list'), findsOneWidget);
  });
}