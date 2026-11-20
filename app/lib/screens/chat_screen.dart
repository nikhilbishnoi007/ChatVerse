import 'package:chatverse/services/database.dart';
import 'package:chatverse/services/shared_prefrence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String username;
  final String chatRoomId;
  final String dp;
  const ChatScreen({
    super.key,
    required this.username,
    required this.chatRoomId,
    required this.name,
    required this.dp,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messagecontroller = TextEditingController();
  String? myName, myProfilePic, myEmail, myUsername, messageId;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream;
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

  Future<void> addMessage() async {
    final message = _messagecontroller.text.trim();
    final me = myUsername;
    if (message.isEmpty || me == null) return;
    _messagecontroller.clear();
    try {
      final db = DatabaseMethods();
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": me,
        "time": FieldValue.serverTimestamp(),
      };
      Map<String, dynamic> info = {
        "lastMessage": message,
        "lastMessageSendBy": me,
        "lastMessageTime": FieldValue.serverTimestamp(),
      };
      await db.addMessage(widget.chatRoomId, messageInfoMap);
      await db.updateLastMessage(widget.chatRoomId, info);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesStream = DatabaseMethods().getMessages(widget.chatRoomId);
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Color(0xFFF1F5F9),
                      size: 24,
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF3B5BA9),
                    backgroundImage: widget.dp.isNotEmpty
                        ? NetworkImage(widget.dp)
                        : null,
                    child: widget.dp.isEmpty
                        ? Text(
                            widget.username.isNotEmpty
                                ? widget.username[0]
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '@${widget.username}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF93C5FD),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: _messagesStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                   debugPrint('Messages error: ${snapshot.error}');
                                  return const Center(
                                    child: Text('Something went wrong'),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final docs = snapshot.data!.docs;
                                if (docs.isEmpty) {
                                  return const Center(child: Text("Say hii"));
                                }
                                return ListView.builder(
                                  reverse: true,
                                  padding: EdgeInsets.all(20),
                                  itemCount: docs.length,
                                  itemBuilder: (context, i) {
                                    final data = docs[i].data();
                                    final isMe = data['sendBy'] == myUsername;
                                    final ts = data['time'] as Timestamp?;
                                    final time = ts == null
                                        ? ""
                                        : DateFormat("h:mm a")
                                              .format(ts.toDate());
                                    return Align(
                                      alignment: isMe
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.67,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? const Color(0xFF1E3A8A)
                                              : const Color(0xFFE5E7EB),
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(12),
                                            topRight: const Radius.circular(12),
                                            bottomLeft: Radius.circular(
                                              isMe ? 12 : 0,
                                            ),
                                            bottomRight: Radius.circular(
                                              isMe ? 0 : 12,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              data['message'] ?? "",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: isMe
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              time,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isMe
                                                    ? Colors.white70
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messagecontroller,
                                minLines: 1,
                                maxLines: 5,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(color: Colors.black87),
                                cursorColor: const Color(0xFF1E3A8A),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFEFF6FF),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                addMessage();
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                              ),
                              icon: const Icon(
                                CupertinoIcons.paperplane_fill,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
