import 'package:chatapp/screens/add_user_in_group.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/chats_screen.dart';
import 'package:chatapp/screens/groupDetails.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:chatapp/widgets/Navigationbar.dart';
import 'package:chatapp/widgets/navigationDrawer.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/edit_user_information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatapp/screens/home_page.dart';


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
      //  home: ChatsScreen(),
      initialRoute: _auth.currentUser != null 
      ? Navigationbar.ScreenRoute
      : WelcomeScreen.ScreenRoute,


      routes: {
        WelcomeScreen.ScreenRoute:(context) => WelcomeScreen(),
        LoginScreen.ScreenRoute:(context) => LoginScreen(),
        SignupScreen.ScreenRoute:(context) => SignupScreen(),
        ChatScreen.ScreenRoute:(context) => ChatScreen(),
        HomePage.screenRoute:(context) => HomePage(),
        Navigationbar.ScreenRoute :(context) => Navigationbar(),
        EditUser.ScreenRoute :(context) => EditUser(),
        ChatsScreen.ScreenRoute : (context) => ChatsScreen(),
        ProfileScreen.ScreenRoute: (context) => ProfileScreen(),
        Groupdetails.ScreenRoute: (context) => Groupdetails(),
        AddUserGroup.ScreenRoute :(context) => AddUserGroup(),
        // AudioMessageSender.ScreenRoute :(context) => AudioMessageSender(),
        
        
      }
    );
  }
}

