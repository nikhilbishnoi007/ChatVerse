import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
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
                // mainAxisAlignment: .spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Color.fromARGB(
                        255,
                        194,
                        195,
                        197,
                      ).withValues(alpha: 1.2),
                      size: 26,
                    ),
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Color(0xFFF1F5F9),
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
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
                  Container(
                    padding: EdgeInsets.all(8),
                   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 210, 213, 219),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                    ),
                    child: Text("Hello how was the day?",style: TextStyle(fontSize: 15),),
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
