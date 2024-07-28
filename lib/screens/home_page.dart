
import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chats_screen.dart';
import 'profile_screen.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
final currentUser = _auth.currentUser;



class HomePage extends StatefulWidget {
  static const String screenRoute = 'Home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  
    //bottom Navigation bar pages 


  @override
  void initState() {
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: UsersWidget(),      
        ),
      ),
    );
  }
}

class UsersWidget extends StatelessWidget {
  UsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        List<UserLine> usersNames = [];
        for (var user in snapshot.data!.docs) {
          if (_auth.currentUser?.uid != user.id){
              final userName = user.get('name');
              final imageUrl = user.get('profilePicture');
              final userWidget = UserLine(user: userName , uid : user .id , image : imageUrl );
              usersNames.add(userWidget);
          }
          
        }

        return Expanded(
          child: ListView(
            
            children: usersNames,
            
          ),
        );
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
      children: [
      
        Padding(
          padding: const EdgeInsets.only(  left: 20),
          child: Material(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                  arguments: this.uid != null
                  ? this.uid
                  : 'default'   );
                  
                },
                
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2), // Thickness of the border
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff604CD4),),
                      child: CircleAvatar(
                          foregroundColor: Colors.amber,
                          
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: image != null ? NetworkImage(image) : null,
                          child: image == null
                              ? Icon(
                                  Icons.account_circle,
                                  size: 20,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                    ),
                      SizedBox(width: 20,),
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
        ),
        
      ],
    );
  }
}
