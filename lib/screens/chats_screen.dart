import 'package:chatapp/screens/notifications_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/customTabBar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsScreen extends StatefulWidget {
   ChatsScreen({super.key});
  static const String ScreenRoute = 'chats_screen';
  
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}
final _auth = FirebaseAuth.instance;
final _database = FirebaseDatabase.instance;

void _updateUserStatus(String userId, bool isOnline) {
    DatabaseReference userRef = _database.ref().child('users').child(userId);

    userRef.onDisconnect().update({'isOnline': false});
    userRef.update({'isOnline': isOnline});
  }
 


  
class _ChatsScreenState extends State<ChatsScreen> {
  
    @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _updateUserStatus(user.uid, true);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        
        child: Padding(
          padding: const EdgeInsets.only(top : 20, left: 10),
          child: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: Colors.amber,
            title: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ProfileScreen.ScreenRoute);
                        },
                    child: UserWidget(user : _auth.currentUser!.uid)),
          actions: [
            Icon(
                Icons.search ,
                color: Color(0xFF604CD4),
                size: 30,
              ),
              SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: (){
                   Navigator.pushNamed(context, NotificationScreen.screenRoute);
                },
                icon : const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF604CD4),
                  size: 30,   
                  ) ,
                
              ),
            ),
            
            
          ],    
          ),
        ),
      ),
      body: CustomTabBar(),
      
    );
  }
}