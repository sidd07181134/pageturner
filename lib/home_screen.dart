import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'user_preferences_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookListScreen()),
            ),
            child: const Text('View Recommended Books'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserPreferencesScreen()),
            ),
            child: const Text('Set Preferences'),
          ),
        ],
      ),
    );
  }
}
