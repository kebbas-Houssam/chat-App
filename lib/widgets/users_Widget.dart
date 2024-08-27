import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersWidget extends StatelessWidget {
  UsersWidget({super.key});
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No users found');
        }

        List<UserWidget> usersNames = [];
        for (var user in snapshot.data!.docs) {
          if (_auth.currentUser?.uid != user.id){

              usersNames.add(UserWidget(user: user.id));
          }
          
        }
        return Expanded(
          child: ListView(
            
            children: usersNames,
            
          ),
        );
      },
    );
  }
}
