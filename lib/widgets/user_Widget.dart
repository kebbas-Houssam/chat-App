import 'package:chatapp/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserWidget extends StatelessWidget {
  UserWidget({super.key , required this.user });
  final String user ;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user).snapshots(),
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
        
        Map<String, dynamic>? user = snapshot.data!.data() as Map<String, dynamic>?;
         final userName = user?['name'] ;
         final imageUrl = user?['profilePicture'] ;

        return UserLine(user: userName , uid : this.user , image : imageUrl );
        
      },
    );
  }
}

class UserLine extends StatelessWidget {
  const UserLine({super.key, required this.user , required this.image, required this.uid });
  final String user;
  final String uid;
  final String image;
  
  
  @override
  Widget build(BuildContext context) {
    //add user image
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      
        Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: MaterialButton(
              onPressed: () {
                 List members = [uid] ;
                //  members.add(uid);
                Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                arguments: members != null && members.isNotEmpty
                ? members
                : 'default'   );
                
              },
              
              child: Row(
                children: [
                  Stack(
                    children:[ 
                      CircleAvatar(
                      foregroundColor: Colors.amber,
                      
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: image != null && image.isNotEmpty
                       ? NetworkImage(image)
                       : null,  
                      child: image == null || image.isEmpty
                          ? Icon(
                              Icons.account_circle,
                              size: 20,
                              color: Colors.grey,
                            )
                          : null,
                    ),                      
                    ]
                  ),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$user',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      ),
                      Text('Hi Hellooooo',
                            style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                            
                            )
                    ],
                  ),
                ],
              ),
            ),
            
          ),
        ),
        
      ],
    );
  }
}

