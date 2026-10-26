import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/bank_account.dart';
import 'models/library.dart';
import 'models/library_item.dart';
import 'models/book.dart';
import 'models/magazine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  
    User user1 = User(name: 'Andrei Popa', age: 25, email: 'andrei@yahoo.com');
    User user2 = User(name: 'Elena Vasilescu', email: 'elena@gmail.com');
    User user3 = User(name: 'Mihai Ionescu');

    final List<User> users = [user1, user2, user3];

    BankAccount account1 = BankAccount(
      holderName: 'Ion Popescu', 
      balance: 1250.50, 
      bankBranch: 'Bucuresti Central',
    );
    account1.initializeAccount('RO49RNCB00001234567890');

    final List<BankAccount> accounts = [
      account1,
      BankAccount(holderName: 'Maria Ionescu', balance: 450.00),
    ];

    Library library = Library();
    library.addItem(Book(
      title: 'Dart Programming', 
      author: 'John Doe', 
      publishDate: '2021', 
      pageCount: 300, 
      isbn: '978-3-16-148410-0'
    ));
    library.addItem(Magazine(
      title: 'Tech Weekly', 
      publisher: 'Tech Media', 
      issueNumber: 42
    ));

    List<LibraryItem> searchResults = library.searchByTitle('Dart');
    if (searchResults.isNotEmpty) {
      library.borrowItem(searchResults.first, user1, '2026-06-01');
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Lab 2 - Library & Management App')),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Task I: Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...users.map((user) => ListTile(
              title: Text(user.name),
              subtitle: Text('Email: ${user.email ?? 'Not provided'}'),
              trailing: Text('Age: ${user.getDisplayAge()}'),
            )),

            const Divider(),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Task II: Bank Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...accounts.map((account) => ListTile(
              title: Text(account.holderName),
              subtitle: Text('Branch: ${account.bankBranch ?? 'N/A'} | Balance: \$${account.balance}'),
              trailing: Text(account.checkNumber()),
            )),

            const Divider(),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Task III: Library Items & Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...library.items.map((item) => ListTile(
              title: Text(item.title),
              subtitle: Text('Author: ${item.author ?? 'Unknown'} | Borrower: ${item.borrower?.name ?? 'Available'}'),
              trailing: Text(item.dueDate != null ? 'Due: ${item.dueDate}' : 'Not borrowed'),
            )),
          ],
        ),
      ),
    );
  }
}