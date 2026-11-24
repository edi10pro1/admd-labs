import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    this.userId = 1,
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        userId: json['userId'] as int? ?? 1,
        id: json['id'] as int,
        title: json['title'] as String,
        completed: json['completed'] as bool? ?? false,
      );

  Todo copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
  }) =>
      Todo(
        userId: userId ?? this.userId,
        id: id ?? this.id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );

  @override
  List<Object?> get props => [userId, id, title, completed];
}