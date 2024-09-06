import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/time_service.dart';
import 'package:chatapp/widgets/user_Widget.dart';
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

    Stream<String> getLastMessage(String sender, String receiver) {
  return _firestore
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isEmpty) {
      return 'say hi!';
    }

    for (var msg in snapshot.docs) {
      Map<String, dynamic> data = msg.data() as Map<String, dynamic>;
      String messageSender = data['sender'];
      List<dynamic> messageReceivers = data['receiver'];
      Timestamp messageTime = data['time'];
         String time = _timeService.formatMessageTime(messageTime.millisecondsSinceEpoch);
      if ((messageSender == sender && messageReceivers.contains(receiver)) ||
          (messageSender == receiver && messageReceivers.contains(sender))) {
        String messageType = data['type'];
        switch (messageType) {
          case 'messageText':
            return messageSender == _auth.currentUser!.uid ? "You: ${_timeService.truncateText(data['text'], 15)}   .$time" : "${_timeService.truncateText(data['text'], 20)}   .$time" ;
          case 'messageImage':
            return messageSender == _auth.currentUser!.uid ? "You: send image   .$time"  : 'send image   .$time' ;
          case 'audio':
               return messageSender == _auth.currentUser!.uid ? "You: send message vocale   .$time"  : 'send message vocale   .$time' ;
          default:
            return 'message';
        }
      }
    }
    return 'say hi!';
  });
}
   
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
          
          friendsList.add   (
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
                 padding: const EdgeInsets.only(top : 20),
                 child: StreamBuilder<String>(
                  stream: getLastMessage(_auth.currentUser!.uid , friend),
                  builder: (context , messageSnapshot){

                    if (messageSnapshot.hasError){
                      return const Text('no message');
                    }
                    return UserWidget(
                      user: friend , 
                      userImageRaduis: 22,
                      text: messageSnapshot.data ?? 'no message');
                  }
                   ),//
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