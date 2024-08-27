import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserStatusWidget extends StatelessWidget {
  final String userId;

  UserStatusWidget({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref().child('status/$userId/online').onValue,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data != null) {
          bool isOnline = snapshot.data.snapshot.value ?? false;
          print(isOnline);
          return Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.red,
            ),
          );
        } 
        return Container();
      },
    );
  }
}