import "package:chatverse/screens/chat_screen.dart";
import "package:chatverse/services/database.dart";
import "package:chatverse/services/shared_prefrence.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class SearchResult extends StatefulWidget {
  final String query;
  const SearchResult({super.key, required this.query});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String? myName, myProfilePic, myEmail, myUsername;
  Future<void> getDetails() async {
    final prefs = SharedPrefrenceHelper();
    final name = await prefs.getUserDisplayName();
    final pic = await prefs.getUserProfile();
    final email = await prefs.getUserEmail();
    final username = await prefs.getUserName();

    if (!mounted) return;
    setState(() {
      myName = name;
      myProfilePic = pic;
      myEmail = email;
      myUsername = username;
    });
  }

  String getChatRoomIdByUsername(String a, String b) {
    return a.compareTo(b) > 0 ? '${b}_$a' : '${a}_$b';
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseMethods().searchUsers(widget.query),
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
            final username = (user['username'] ?? '') as String;

            return ListTile(
              onTap: () async {
                final me = myUsername;
                if (username.isEmpty || me == null || me.isEmpty) return;
                FocusScope.of(context).unfocus();
                final chatRoomId = getChatRoomIdByUsername(me, username);
                Map<String, dynamic> chatRoomInfoMap = {
                  "users": [me, username],
                };
                try {
                  await DatabaseMethods().createChatRoom(
                    chatRoomId,
                    chatRoomInfoMap,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      username: username,
                      chatRoomId: chatRoomId,
                      name: name,
                      dp: dp,
                    ),
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
              subtitle: Text('@$username'),
            );
          },
        );
      },
    );
  }
}
