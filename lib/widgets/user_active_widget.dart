import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/get_last_seen.dart';
import 'package:chatapp/widgets/user_status_circul.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserActiveWidget extends StatefulWidget {
  UserActiveWidget({super.key});

  @override
  _UserActiveWidgetState createState() => _UserActiveWidgetState();
}

class _UserActiveWidgetState extends State<UserActiveWidget> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  GetLastSeen _getLastSeen = GetLastSeen();
  
  Future<List<Widget>> _getActiveUsers(List userFriends) async {
    List<Widget> activeUsers = [];

    for (var friend in userFriends) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(friend).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['status'] == "online") {
          activeUsers.add(
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 25),
              child: GestureDetector(
                     onTap: () async {
                     String lastSeenString = await _getLastSeen.getLastseen(friend);
                     Map <String , dynamic> data = 
                     { 
                      'type' : 'user',
                      'id': friend,
                      'lastSeen' : lastSeenString,
                        } ;
                     Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                     arguments: data != null && data.isNotEmpty
                     ? data
                     : 'default'   );
              },
                child: UserStatusCircul(
                  userId: friend,
                  userPictureRaduis: 28,
                ),
              ),
            ),
          );
        }
      }
    }
    return activeUsers;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const Text('No data found');
        }

        final List userFriends = snapshot.data!['friends'];

        return FutureBuilder<List<Widget>>(
          future: _getActiveUsers(userFriends),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox.shrink();
            }
            
            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!,
            );
          },
        );
      },
    );
  }
}
