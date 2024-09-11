import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/get_message.dart';
import 'package:chatapp/services/time_service.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:chatapp/widgets/user_active_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TimeService _timeService = TimeService();
  GetMessage _getMessage = GetMessage(); 

  List <dynamic> lastUSerMessage = [];

  
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder <DocumentSnapshot>(
        stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context , snapshot){

        if (snapshot.hasError) {
            print('Something went wrong');
            return const SizedBox.shrink();
        }

        if (!snapshot.hasData ) {
          print('No users found');
          return const SizedBox.shrink();
        }
         List <Widget> friendsList  = [];

         for (var friend in snapshot!.data?['friends']){
            friendsList.add (
            GestureDetector(
               onTap: () async {
                     String lastSeenString = await _timeService.getLastseen(friend);
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
               child: Padding(
                 padding: const EdgeInsets.only(top : 15),
                 child: StreamBuilder<dynamic>(
                 stream: _getMessage.getLastMessage(_auth.currentUser?.uid ?? 'user', friend,friend),
                 builder: (context, messageSnapshot) {
                   if (messageSnapshot.hasError) {
                    
                     print('No message');
                   }
               
                   if (!messageSnapshot.hasData || messageSnapshot.data == null) {
                     print('No message');
                   }
                   
                  
                   Map<String, dynamic>? lastMessage = messageSnapshot.data as Map<String, dynamic>?;
               
                   return Expanded(
                     child: UserWidget(
                       user: friend,
                       userImageRaduis: 23,
                       text: lastMessage != null &&  lastMessage['text'] != null ?  lastMessage['text'] : 'No message',
                     ),
                   );
                 },
              ),

               )));
         }
        return ListView(
          children: friendsList,
        );
        }),
    );
  }
}
