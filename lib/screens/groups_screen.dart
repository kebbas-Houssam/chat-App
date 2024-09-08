import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/createGroup.dart';
import 'package:chatapp/services/get_message.dart';
import 'package:chatapp/widgets/group_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        preferredSize: Size.fromHeight(80),  // التحكم بارتفاع الـ AppBar
        child: Padding(
          padding: const EdgeInsets.only(left: 30 , right: 30 ,top: 30),
          child: AppBar(
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
            backgroundColor: Colors.transparent, // جعل الخلفية شفافة إذا أردت
        ),
       ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("waiting network");
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something is wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No group found'));
          }

          List<Widget> groupsList = [];

          for (var group in snapshot.data!.docs) {

            List members = group.get('members');
            List <String> membersId = [];

            for (var user in members){          
              membersId.add(user['id']);
              };
              bool isGroupContaineCurrentUser = membersId.contains(_auth.currentUser!.uid);
              bool rebuildWidget = true;
              int i = 0;

              for (var user in membersId) {

              if (isGroupContaineCurrentUser && user != _auth.currentUser!.uid && rebuildWidget){
                print(rebuildWidget);
              groupsList.add(
                GestureDetector(
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

                  child: StreamBuilder<dynamic>(
                    stream: _getMessage.getLastMessage(_auth.currentUser!.uid, user,group.id),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.hasError) {
                     return const Text('No message');
                   }
               
                   if (!messageSnapshot.hasData || messageSnapshot.data == null) {
                     return const Text('No message');
                   }
                      
                      Map<String, dynamic> lastMessage = messageSnapshot.data  ;
                
                      if (lastMessage['newGroupe'] == false &&  rebuildWidget){
                      rebuildWidget = false;
                      return GroupWidget(
                        group: group.id , 
                        text: lastMessage != null && lastMessage['text'] != null ? lastMessage['text'] : 'No message',);
                      }
                      else{
                           i= i+1;
                           if (i == membersId.length-1){
                             return GroupWidget(
                                  group: group.id , 
                                  text: lastMessage != null && lastMessage['text'] != null ? lastMessage['text'] : 'No message',);
                           }
                           else 
                            return SizedBox.shrink();

                        }
                      }
                    
                  )
                  )
                );
            }
            } 
          }

          return ListView(
            children: groupsList,
          );
        },
      ),
    );
  }
}
