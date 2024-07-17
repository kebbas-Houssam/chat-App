import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Me',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: ChatScreen(),
      initialRoute: _auth.currentUser != null 
      ? ChatScreen.ScreenRoute 
      : WelcomeScreen.ScreenRoute,
      routes: {
        WelcomeScreen.ScreenRoute:(context) => WelcomeScreen(),
        LoginScreen.ScreenRoute:(context) => LoginScreen(),
        SignupScreen.ScreenRoute:(context) => SignupScreen(),
        ChatScreen.ScreenRoute:(context) => ChatScreen(),

      }
    );
  }
}

