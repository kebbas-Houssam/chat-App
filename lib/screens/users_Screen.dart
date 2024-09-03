import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    late bool invSend = false ;
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
        
        List currentUserFriends = [];
        List currentUserFriendRequest = [];
        for (var user in snapshot.data!.docs ){
            if (user.id == _auth.currentUser!.uid){
              currentUserFriends = user['friends'];
              currentUserFriendRequest = user['fiendReduest'];
            }
        }

        List<Widget> usersRequested = [];// user <-
        List<Widget> usersnotRequested = [];//user ->
        
        for (var user in snapshot.data!.docs) {
          if (_auth.currentUser?.uid != user.id ){
             for (var friend in currentUserFriends){
                if (user.id != friend) {
                for (var request in currentUserFriendRequest){
                  if (user.id == request){
                    usersRequested.add(
                      Row(
                        children: [
                          UserWidget(user: user.id , userImageRaduis: 25,text: '',),
                          SizedBox(width: 10,),
                          IconButton(
                            onPressed: (){
                              setState(() {
                          currentUserFriends.add(request);
                          currentUserFriendRequest.remove(request);
                          _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                            'friends': currentUserFriends,
                            'fiendReduest': currentUserFriendRequest,
                          });
                        });
                            }, 
                            icon: const Icon(
                              Icons.person_add,
                              color: Color(0xFF604CD4),
                              size: 30,)),
                        IconButton(
                      onPressed: () {
                        setState(() {
                          currentUserFriendRequest.remove(request);
                          _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                            'fiendReduest': currentUserFriendRequest,
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF604CD4),
                        size: 30,
                      ),
                    ),
                        ],
                      )
                    );
                    
                  } 
                  break;
                }
                    
                  
                

                // usersNames.add(
                // Row(
                //   children: [
                //     UserWidget(user: user.id),
                //     SizedBox(width: 70,),
                //     IconButton(
                //       onPressed: (){
                //            setState(() {
                //               friendRequest.add(_auth.currentUser!.uid);
                //            });
                //            _firestore.collection('users').doc(user.id).update(
                //             {
                //               'fiendReduest' : friendRequest
                //             }
                //            );
                //       },
                //       icon: !invSend ? const Icon( 
                //         Icons.person_add,
                //         color: Color(0xFF604CD4),
                //         size: 30, )
                //                      : const Icon( 
                //         Icons.swipe_up_alt_rounded,
                //         color: Colors.green,
                //         size: 30, ))
                          
                //   ],
                // ));
              }
              break;
             }
             usersnotRequested.add(
                    Row(
                     children: [
                      UserWidget(user: user.id , userImageRaduis: 25,text: '',),
                      SizedBox(width: 10,),
                      IconButton(
                        onPressed: (){
                          setState(() {
                              currentUserFriendRequest.add(_auth.currentUser!.uid);
                           });
                           _firestore.collection('users').doc(user.id).update(
                            {
                              'fiendReduest' : currentUserFriendRequest
                            }
                           );
                        },
                        icon:const Icon(
                          Icons.person_add,
                        color: Color(0xFF604CD4),
                        size: 30,
                        ))

                     ],
                    )
                    );
              
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top : 40),
          child: Column(
            children: [
              Text('Users Requests :'),
              SizedBox(
                 height: usersRequested.length * 100, // تخصيص الارتفاع حسب طول القائمة
                 child: ListView(
                   children: usersRequested,
                 ),
               ),
              Text('Auther Users'),
              SizedBox(
                 height: usersnotRequested.length * 80, // تخصيص الارتفاع حسب طول القائمة
                 child: ListView(
                   children: usersnotRequested,
                 ),
               ),
            ],
          ),
        );
      },
    ) 
    );
  }
}