import 'package:chatverse/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatverse/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  Future<bool> confirmLogout(BuildContext context) async {
    final res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("LogOut"),
          content: Text("Are you sure you want to logout"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("LogOut", style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
    return res ?? false;
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (value) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentdate = DateTime.now();
    final format = DateFormat("h:mm a").format(currentdate);
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Container(
        key: ValueKey("container"),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    "ChatVerse",
                    style: TextStyle(
                      color: Color(0xFFF1F5F9),
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.search,
                      color: Color.fromARGB(
                        255,
                        194,
                        195,
                        197,
                      ).withValues(alpha: 1.2),
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(username: "Username",)),
                      );
                    },
                    leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
                    title: Text("Username"),
                    subtitle: Text("Last message from this user"),
                    trailing: Text(format),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
