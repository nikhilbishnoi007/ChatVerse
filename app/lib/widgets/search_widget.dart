import "package:chatverse/screens/chat_screen.dart";
import "package:chatverse/services/database.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class SearchResult extends StatelessWidget {
  final String query;
  const SearchResult({super.key, required this.query});


  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseMethods().searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        final users = (snapshot.data?.docs ?? [])
            .map((d) => d.data())
            .where((u) => u['uid'] != myId)
            .toList();

        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, i) {
            final user = users[i];
            final name = (user['name'] ?? '') as String;
            final dp = (user['dp'] ?? '') as String;

            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(username: user['username']),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1E3A8A),
                backgroundImage: dp.isNotEmpty ? NetworkImage(dp) : null,
                child: dp.isEmpty
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              title: Text(name),
              subtitle: Text('@${user['username']}'),
            );
          },
        );
      },
    );
  }
}
