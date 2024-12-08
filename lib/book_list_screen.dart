import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookListScreen extends StatelessWidget {
  const BookListScreen({Key? key}) : super(key: key);

  // Function to fetch books using Google Books API
  Future<List<Map<String, dynamic>>> fetchBooks(String query) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
    try {
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the response has "items"
        if (data['items'] != null) {
          return (data['items'] as List<dynamic>).map((item) {
            final volumeInfo = item['volumeInfo'] ?? {};
            return {
              'title': volumeInfo['title'] ?? 'No Title Available',
              'author': (volumeInfo['authors'] as List<dynamic>?)
                      ?.join(', ') ??
                  'Unknown Author',
              'thumbnail': (volumeInfo['imageLinks']?['thumbnail']) ??
                  '', // Add thumbnail support
            };
          }).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch books. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Books'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
      
        builder: (context, snapshot) {
          // Handle different states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found.'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: book['thumbnail']!.isNotEmpty
                      ? Image.network(
                          book['thumbnail']!,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.book, size: 50),
                  title: Text(book['title']!),
                  subtitle: Text(book['author']!),
                ),
              );
            },
          );
        }, future: null,
      ),
    );
  }
}
