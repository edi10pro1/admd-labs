import 'user.dart';
import 'library_item.dart';

abstract class LibraryItem {
  final String title;
  final String? author;
  final String? publishDate;
  User? borrower;
  String? dueDate;

  LibraryItem({
    required this.title,
    this.author,
    this.publishDate,
    this.borrower,
    this.dueDate,
  });


}