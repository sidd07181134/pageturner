import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscussionScreen extends StatelessWidget {
  final String bookId;

  DiscussionScreen({required this.bookId});

  @override
  Widget build(BuildContext context) {
    TextEditingController discussionController = TextEditingController();

    void postDiscussion() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('discussions').add({
          'bookId': bookId,
          'userId': user.uid,
          'content': discussionController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        discussionController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Discussions')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('discussions')
                  .where('bookId', isEqualTo: bookId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final discussions = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = discussions[index];
                    return ListTile(
                      title: Text(discussion['content']),
                      subtitle: Text('User: ${discussion['userId']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: discussionController,
                    decoration: const InputDecoration(hintText: 'Add your thoughts...'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: postDiscussion),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
