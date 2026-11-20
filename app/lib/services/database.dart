import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final db = FirebaseFirestore.instance.collection("users");
  final chat = FirebaseFirestore.instance.collection("chatrooms");

  Future addUser(Map<String, dynamic> userinfo, String id) async {
    return await db.doc(id).set(userinfo);
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return db.where("email", isEqualTo: email).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchUsers(String query) {
    return db
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: '$query\uf8ff')
        .limit(20)
        .snapshots();
  }

  Future<bool> createChatRoom(
    String chatRoomId,
    Map<String, dynamic> chatRoomInfo,
  ) async {
    final snapShot = await chat.doc(chatRoomId).get();
    if (snapShot.exists) return true;
    await chat.doc(chatRoomId).set(chatRoomInfo);
    return false;
  }

  Future<void> addMessage(
    String chatRoomId,
    Map<String, dynamic> messageInfo,
  ) async {
    await chat.doc(chatRoomId).collection("chats").add(messageInfo);
  }

  Future<void> updateLastMessage(
    String chatRoomId,
    Map<String, dynamic> info,
  ) async {
    await chat.doc(chatRoomId).set(info, SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return chat
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }
}
