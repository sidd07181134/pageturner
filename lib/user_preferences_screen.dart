import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPreferencesScreen extends StatelessWidget {
  const UserPreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController genreController = TextEditingController();

    void savePreferences() async {
      await FirebaseFirestore.instance.collection('users').doc('user_id').set({
        'preferredGenre': genreController.text,
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: genreController, decoration: const InputDecoration(labelText: 'Preferred Genre')),
            ElevatedButton(onPressed: savePreferences, child: const Text('Save Preferences')),
          ],
        ),
      ),
    );
  }
}
