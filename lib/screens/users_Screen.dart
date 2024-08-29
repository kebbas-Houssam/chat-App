import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
   UsersScreen({super.key});
  static const String screenRoute = 'UsersScreen';


  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


    @override
  void initState() {
    super.initState();
    
  }
  @override
  void dispose() {
    super.dispose();
    
  }


 @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body:StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No users found');
        }
        
        List<Widget> usersNames = [];
        
        for (var user in snapshot.data!.docs) {
          if (_auth.currentUser?.uid != user.id ){
            //  for (var friend in user['friends']){
            //   if (user.id != friend) {
                List friendRequest = user['fiendReduest'];
                usersNames.add(
                GestureDetector(
                  onTap: () {
                     Map <String , dynamic> data = 
                     { 
                      'type' : 'user',
                      'id': user.id
                        } ;
                     Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                     arguments: data != null && data.isNotEmpty
                     ? data
                     : 'default'   );
              },
                  child: Row(
                    children: [
                      UserWidget(user: user.id),
                      SizedBox(width: 70,),
                      IconButton(
                        onPressed: (){
                             setState(() {
                                friendRequest.add(_auth.currentUser!.uid);
                             });
                             _firestore.collection('users').doc(user.id).update(
                              {
                                'fiendReduest' : friendRequest
                              }
                             );
                        },
                        icon: Icon(
                          Icons.person_add,
                          color: Color(0xFF604CD4),
                          size: 30, ))
                    ],
                  )
                  ));
              }
             }
              
              
        //   }
        // }
        return Expanded(
          child: ListView(
            
            children: usersNames,
            
          ),
        );
      },
    ) 
    );
  }
}