import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/createGroup.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groups'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
              print(membersId);
            if (user['id'] == _auth.currentUser?.uid) {
              groupsList.add(
                GestureDetector(
                  onTap: (){
                    Map <String , dynamic > data  = 
                    {
                      'type' : 'group' ,
                      'id' : group.id ,
                      'members' : membersId ,
                    };
                    print(data);
                    
                    Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                       arguments: data != null && data.isNotEmpty
                       ? data
                       : 'default'   );},

                  child: GroupWidget(group: group.id)
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

      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroup()),
          );
        },
        child: const Icon(Icons.group_add),
      ),
    );
  }
}
