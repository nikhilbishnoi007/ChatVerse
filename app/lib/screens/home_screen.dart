
import 'package:firebase_auth/firebase_auth.dart';


import 'package:chatverse/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      drawerEdgeDragWidth: 120,
      appBar: AppBar(title: Text("Home"), centerTitle: true),
      body: Container(),
      drawer: Drawer(
        width: 250,
        child: Column(
          children: [
            SizedBox(height: 100),
            FlutterLogo(size: 100),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () async {
                  final res = await confirmLogout(context);
                  if (res) {
                    if (!context.mounted) return;
                    logout(context);
                  }
                },
                leading: Icon(CupertinoIcons.square_arrow_right),
                title: Text("LogOut", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
