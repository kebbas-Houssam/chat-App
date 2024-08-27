import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key , required this.group});
  final String group ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('groups').doc(group).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const Text('No users found');
        }
        
        Map<String, dynamic>? group = snapshot.data!.data() as Map<String, dynamic>?;
         final groupTitle = group?['title'] ;
         final groupmembers = group?['members'];

         

        return GroupLine(title: groupTitle, id: this.group, members: groupmembers);
        
      },
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
    return 
    GestureDetector(
      onTap: (){
        List group = [];
        group.add(id);
        group.addAll(members);
        Navigator.pushNamed(context, ChatScreen.ScreenRoute,
           arguments: group!= null && group.isNotEmpty
           ? group
           : 'default'   );},

      child: Padding(
        padding: EdgeInsets.only(top : 30 , left: 20),
        child: Row(
          
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(members[0]['profilePicture']),
                  )
                  ),
        
                  Positioned(
                  left: 15,
                  bottom: 15,
                  child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(members[1]['profilePicture']),
                  )
                  ),
              ],
            ),
            SizedBox(width: 35,),
            Text(title , 
                 style : TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                 ), 
                  )
            ],
        ),
      ),
    );
  }
}
