import 'package:chatverse/screens/home_screen.dart';
// import 'package:chatverse/screens/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = FirebaseAuth.instance;
    // bool isLoggedIn = auth.currentUser != null;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatVerse',
      home: HomeScreen()
    );
  }
}
