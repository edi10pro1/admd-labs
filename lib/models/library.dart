import 'library_item.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> items;

  Library({List<LibraryItem>? items}) : items = items ?? [];

  String addItem(LibraryItem? item) {
    if (item != null && item.title.trim().isNotEmpty) {
      items.add(item);
      return "Successfully added";
    }
    return "Could not add item";
  }

  List<LibraryItem> searchByTitle(String? query) {
    if (query == null || query.isEmpty) return [];
    return items.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<LibraryItem> getItemsByAuthor(String? authorName) {
    if (authorName == null || authorName.isEmpty) return [];
    return items.where((item) {
      return item.author != null &&
          item.author!.toLowerCase().contains(authorName.toLowerCase());
    }).toList();
  }

  bool borrowItem(LibraryItem item, User borrowerUser, String dueDate) {
    if (item.borrower != null) {
      return false;
    }
    item.borrower = borrowerUser;
    item.dueDate = dueDate;
    return true;
  }

  void returnItem(LibraryItem item) {
    item.borrower = null;
    item.dueDate = null;
  }
}