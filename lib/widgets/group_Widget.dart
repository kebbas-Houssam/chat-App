import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/services/time_service.dart';
import 'package:chatapp/widgets/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TimeService _timeService = TimeService();

class GroupWidget extends StatelessWidget {
  const GroupWidget({super.key , required this.group , required this.text});
  final String group , text ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('groups').doc(group).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GroupeWidgetShimmer();

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

         

        return GroupLine(title: groupTitle, id: this.group, members: groupmembers , text: this.text,);
        
      },
    );
  }
}

class GroupLine extends StatelessWidget {
  final String title , text;
   final List <dynamic> members;  
   final String id;

   GroupLine({super.key , required this.title , required this.id , required this.members ,required this.text} );

  @override
  Widget build(BuildContext context) {
    int restMembers = members.length - 3;
    return 
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF5F5F5),
                  child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(members[0]['profilePicture']),
                  ),
                ),
                Positioned(
                left: 20,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF5F5F5),
                  child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(members[1]['profilePicture']),
                  ),
                )
                ),
                Positioned(
                left: 40,
                child: restMembers == 0 
                ? CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF5F5F5),
                  child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey,
                  backgroundImage:  NetworkImage(members[2]['profilePicture']),
                  ),
                )
                : CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF5F5F5) ,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A4B62),
                      shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Text('+$restMembers',style: TextStyle(color: Colors.white,fontSize: 16),),
                    ),
                  ),
                )
                ),
            ],
          ),
          SizedBox(width: 55,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_timeService.truncateText(title, 10) , 
                   style: const TextStyle(
                   color: Colors.black,
                   fontSize: 20,
                   fontWeight: FontWeight.bold),
                    ),
              Text( text ,
                    style: TextStyle( color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w300 ,fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1 ,
                    textDirection: TextDirection.ltr,
              )
            ],
          )
          ],
      );
    
  }
}
