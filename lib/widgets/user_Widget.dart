import 'package:chatapp/services/time_service.dart';
import 'package:chatapp/widgets/shimmer.dart';
import 'package:chatapp/widgets/user_status_circul.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

  TimeService _timeService = TimeService();

class UserWidget extends StatelessWidget {
  UserWidget({super.key , required this.user ,required this.userImageRaduis ,required this.text });
  final String user ;
  final double userImageRaduis;
  final String text;
  
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return UserWidgetShimmer();
        }

        if (snapshot.hasError) {
          print('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const Text('No users found');
        }
        
        Map<String, dynamic>? user = snapshot.data!.data() as Map<String, dynamic>?;
         final userName = user?['name'] ;
         final imageUrl = user?['profilePicture'] ;

        return UserLine(user: userName , uid : this.user , image : imageUrl , userImageRaduis : this.userImageRaduis , text : this.text);
        
      },
    );
  }
}

class UserLine extends StatelessWidget {
  const UserLine({super.key, required this.user , required this.image, required this.uid , required this.userImageRaduis , required this.text});
  final String user;
  final String uid;
  final String image;
  final double userImageRaduis;
  final String text;
  
  
  @override
  Widget build(BuildContext context) {
    //add user image
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      
        Row(
          children: [
            UserStatusCircul(userId: uid , userPictureRaduis: 22,),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$user',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
                text.isNotEmpty
                ?Text( text ,
                      style: TextStyle( color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w300 ,fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1 ,
                      textDirection: TextDirection.ltr,
                )
                :SizedBox.shrink()
              ],
            ),
          ],
        ),
        
      ],
    );
  }
}

