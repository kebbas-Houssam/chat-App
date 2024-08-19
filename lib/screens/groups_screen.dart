import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/createGroup.dart';
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
        backgroundColor: Colors.amber,
        title: Text('Goups Page'),
      ),
      body : Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('groups').snapshots(),
              builder: (context , snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }
              
                  if (snapshot.hasError){
                    return Text('Something is wrong');
                  }
              
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return Text('no group fond');
                  }
                  List <GroupLine> groupsList = [];
                   List<dynamic> members =[];
              
                    for (var group in snapshot.data!.docs) {
                        // members.add(group.id);
                        members = group.get('members');
                        // members.addAll(groupMembers);
                      for (var user in members){
                         if (_auth.currentUser?.uid == user['id'] ){
                            final groupId = group.id;
                            final groupTitle= group.get('title');
                            final groupWidget = GroupLine(title : groupTitle , id: groupId,members: members,);
                          groupsList.add(groupWidget);
                      }
                       }
                       }
                    return 
                     ListView(
                       children: groupsList,
                     );          
                    }                  
              
              ),
          ),
          ElevatedButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroup()),
              );
            } ,
            child :  Icon(Icons.group_add)),
        ],
      )
    );
  }
}
class GroupLine extends StatelessWidget {
  final String title;
   final List <dynamic> members;  
   final String id;

   GroupLine({super.key , required this.title , required this.id , required this.members} );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //pictures
        
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15 ,horizontal: 30),
          child: GestureDetector(
            onTap: (){
               List group = [];
               group.add(id);
               group.addAll(members);
               Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                  arguments: group!= null && group.isNotEmpty
                  ? group
                  : 'default'   );
                
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(15),
              width: 0.8*(MediaQuery.of(context).size.width),
              child: Text(title)),
          ),
        ),
          
      ],
    );
  }
}