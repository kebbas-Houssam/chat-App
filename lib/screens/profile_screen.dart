import 'package:chatapp/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String userName = '' ;
  @override
  void initState() {
    super.initState();
    setUserName();
  }

  Future<void> setUserName() async {
    
    if (_auth.currentUser != null) {
      final users = await _firestore.collection('users').get();
      for (var user in users.docs) {
        if (user.get('uid') == _auth.currentUser?.uid) {
          setState(() {
            userName = user.get('name');
          });
          print(userName);
          break;
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, WelcomeScreen.ScreenRoute);  
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                )),
        ],
        backgroundColor: Colors.redAccent[400],
        title: Text('Profile' , style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          children: [
            //add image 
            Center(child: Text(userName , style: TextStyle(color: Colors.black),)),
          ],
        ),
      ),
    );
  }
}