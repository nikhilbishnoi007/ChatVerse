import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
    final db= FirebaseFirestore.instance.collection("users");

  Future addUser(Map<String,dynamic> userinfo,String id)async{
     return await db.doc(id).set(userinfo);
  }
  Future<QuerySnapshot> getUserByEmail(String email)async{
    return db.where("email", isEqualTo: email).get();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> searchUsers(String query) {
  return db
      .where('username', isGreaterThanOrEqualTo: query)
      .where('username', isLessThan: '$query\uf8ff')
      .limit(20)
      .snapshots();
}
}