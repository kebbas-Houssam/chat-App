import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder <DocumentSnapshot>(
        stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context , snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
             return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
            return const Text('Something went wrong');
        }

        if (!snapshot.hasData ) {
          return const Text('No users found');
        }
        //  List friends = snapshot!.data?['friends'];
         List <Widget> friendsList  = [];
         for (var friend in snapshot!.data?['friends']){
          friendsList.add(
            GestureDetector(
               onTap: () {
                     Map <String , dynamic> data = 
                     { 
                      'type' : 'user',
                      'id': friend,
                        } ;
                     Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                     arguments: data != null && data.isNotEmpty
                     ? data
                     : 'default'   );
              },
               child: Padding(
                 padding: const EdgeInsets.only(top : 20),
                 child: UserWidget(user: friend , userImageRaduis: 22,text: 'heloooooooooo',),
               )));
         }
        return
        ListView(
          children: friendsList,
        );
        }),
    );
  }
}