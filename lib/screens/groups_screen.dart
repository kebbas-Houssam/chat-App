import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/createGroup.dart';
import 'package:chatapp/services/get_message.dart';
import 'package:chatapp/widgets/group_Widget.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});
  

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  GetMessage _getMessage = GetMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), 
        child: Padding(
          padding: const EdgeInsets.only( left : 10 ,right: 20 ,top: 30),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5)
              ),
            ),
            title: const Text(
              'Groups',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateGroup()),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ],
            backgroundColor: Colors.transparent, 
        ),
       ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('groups').snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text('error'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('no groups'));
          }

          List<DocumentSnapshot> groups = snapshot.data!.docs;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var group = groups[index];
              List members = group.get('members');
              List<String> membersId = members.map((user) => user['id'] as String).toList();

              if (membersId.contains(_auth.currentUser!.uid)) {
                return StreamBuilder<Map<String, dynamic>>(
                  stream: _getGroupLastMessageStream(group.id, membersId),
                  builder: (context, messageSnapshot) {
                    

                    Map<String, dynamic> lastMessage = messageSnapshot.data ?? {'text': 'no messages', 'newGroupe': true};

                    return GestureDetector(
                      onTap: (){
                    Map <String , dynamic > data  = 
                    {
                      'type' : 'group' ,
                      'id' : group.id ,
                      'members' : membersId ,
                    }; 
                    Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                       arguments: data != null && data.isNotEmpty
                       ? data
                       : 'default'   );},
                      child: Padding(
                        padding: const EdgeInsets.only(left : 20 , top : 30 ),
                        child: GroupWidget(
                          group: group.id,
                          text: lastMessage['text'],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  Stream<Map<String, dynamic>> _getGroupLastMessageStream(String groupId, List<String> membersId) {
    List<Stream> messageStreams = membersId
        .where((userId) => userId != _auth.currentUser!.uid)
        .map((userId) => _getMessage.getLastMessage(_auth.currentUser!.uid, userId, groupId))
        .toList();

    return CombineLatestStream.list(messageStreams).map((messages) {
      for (var message in messages) {
        if (message != 'no data' && message['newGroupe'] == false) {
          return message;
        }
      }
      return {'text': 'say Hi ! ', 'newGroupe': true};
    });
  }
  
}