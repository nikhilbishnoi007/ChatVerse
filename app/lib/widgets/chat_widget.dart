import 'package:chatverse/screens/chat_screen.dart';
import 'package:chatverse/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatefulWidget {
  final String myUsername;
  const ChatList({super.key, required this.myUsername});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  @override
  void initState() {
    super.initState();
    _stream = DatabaseMethods().getMyChatRooms(widget.myUsername);
  }

  String _formateTime(Timestamp ts) {
    final date = ts.toDate();
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    return isToday
        ? DateFormat("h:mm a").format(date)
        : DateFormat("dd MMM").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Chat list error: ${snapshot.error}');
          return Center(child: Text('${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final rooms =
            snapshot.data!.docs
                .where((d) => (d.data()['lastMessage'] ?? '') != '')
                .toList()
              ..sort((a, b) {
                final ta = a.data()['lastMessageTime'] as Timestamp?;
                final tb = b.data()['lastMessageTime'] as Timestamp?;
                if (ta == null) return -1;
                if (tb == null) return 1;
                return tb.compareTo(ta);
              });
        if (rooms.isEmpty) {
          return const Center(
            child: Text('No chats yet. Search a user to start chatting.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: rooms.length,
          itemBuilder: (context, i) {
            final room = rooms[i];
            final data = room.data();
            final users = List<String>.from(data['users'] ?? []);
            final other = users.firstWhere(
              (u) => u != widget.myUsername,
              orElse: () => '',
            );
            if (other.isEmpty) return const SizedBox.shrink();
            final lastMessage = (data['lastMessage'] ?? '') as String;
            final sentByMe = data['lastMessageSendBy'] == widget.myUsername;
            final ts = data['lastMessageTime'] as Timestamp?;
            return FutureBuilder<Map<String, dynamic>?>(
              future: DatabaseMethods().getUserByUsername(other),
              builder: (context, userSnap) {
                final user = userSnap.data;
                final name = (user?['name'] ?? other) as String;
                final dp = (user?['dp'] ?? '') as String;
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          username: other,
                          chatRoomId: room.id,
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
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    sentByMe ? 'You: $lastMessage' : lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    ts == null ? '' : _formateTime(ts),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
