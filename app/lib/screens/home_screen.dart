import 'package:chatverse/screens/chat_screen.dart';
import 'package:chatverse/widgets/search_widget.dart';
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
  bool searching = false;
  final searchController = TextEditingController();
  String query = '';
  // void initiateSearch(String value) {
  //   if (value.isEmpty) {
  //     setState(() {
  //       query = [];
  //       temp = [];
  //     });
  //   }
  //   setState(() {
  //     searching = true;
  //   });
  //   var captalizedValue =
  //       value.substring(0, 1).toUpperCase() + value.substring(1);
  //   if (query.isEmpty && value.length == 1) {}
  // }

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentdate = DateTime.now();
    final format = DateFormat("h:mm a").format(currentdate);
    return PopScope(
      canPop: !searching,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          searching = false;
          searchController.clear();
          query = '';
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF1E3A8A),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        child: searching
                            ? TextField(
                                controller: searchController,
                                autofocus: true,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.search,
                                onChanged: (value) {
                                  setState(
                                    () => query = value.trim().toLowerCase(),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search users...',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF93C5FD),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(
                                    alpha: 0.12,
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              )
                            : const Text(
                                "ChatVerse",
                                style: TextStyle(
                                  color: Color(0xFFF1F5F9),
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (searching) {
                              searchController.clear();
                              query = '';
                            }
                            searching = !searching;
                          });
                        },
                        icon: Icon(
                          searching
                              ? CupertinoIcons.xmark
                              : CupertinoIcons.search,
                          color: const Color(0xFFC2C3C5),
                          size: 26,
                        ),
                      ),
                      PopupMenuButton<String>(
                        elevation: 6,
                        offset: const Offset(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        icon: const Icon(
                          Icons.more_vert,
                          color: Color(0xFFC2C3C5),
                        ),
                        onSelected: (value) async {
                          if (value == "logout") {
                            final response = await confirmLogout(context);
                            if (response) {
                              if (!context.mounted) return;
                              logout(context);
                            }
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'logout', child: Text('Logout')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: (searching && query.isNotEmpty)
                        ? SearchResult(query: query)
                        : ListView(
                            padding: const EdgeInsets.only(top: 8),
                            children: [
                              ListTile(
                                onTap: () {
                                  setState(() => searching = false);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      reverseTransitionDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => const ChatScreen(
                                            username: "Username",
                                          ),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            final curved = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOutCubic,
                                            );
                                            return FadeTransition(
                                              opacity: curved,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0.15, 0),
                                                  end: Offset.zero,
                                                ).animate(curved),
                                                child: child,
                                              ),
                                            );
                                          },
                                    ),
                                  );
                                },
                                leading: const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                                title: const Text("Username"),
                                subtitle: const Text(
                                  "Last message from this user",
                                ),
                                trailing: Text(format),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
