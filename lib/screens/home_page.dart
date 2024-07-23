
import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    setUserName();
  }

  Future<void> setUserName() async {
    
    if (currentUser != null) {
      final users = await _firestore.collection('users').get();
      for (var user in users.docs) {
        if (user.get('uid') == currentUser?.uid) {
          setState(() {
            userName = user.get('name');
          });
          print(userName);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
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
          if (_auth.currentUser?.uid != user.get('uid')){
              final userName = user.get('name');
              final uid = user.get('uid');
              final userWidget = UserLine(user: userName , uid : uid );
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
  const UserLine({super.key, required this.user , required this.uid });
  final String user;
  final String uid;
  @override
  Widget build(BuildContext context) {
    //add user image
    return Row(
      children: [
       
        Padding(
          padding: const EdgeInsets.only(top: 20 , left: 20),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.amber[600],
            child: Padding(
              
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatScreen.ScreenRoute,
                  arguments: this.uid != null
                  ? this.uid
                  : 'default'   );
                  
                },
                child: Text(
                  '$user',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              
            ),
          ),
        ),
        
      ],
    );
  }
}
