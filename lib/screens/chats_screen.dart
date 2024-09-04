import 'package:chatapp/screens/friends_screen.dart';
import 'package:chatapp/screens/notifications_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/services/user_status_service.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:chatapp/widgets/user_active_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
 
class _ChatsScreenState extends State<ChatsScreen> {

 UserStatusService _userStatusService = UserStatusService(); 
    @override
  void initState() {
    super.initState();
    _userStatusService.updateUserStatus(_auth.currentUser!.uid, 'online');
    _userStatusService.setRealtimeDatabaseStatus(_auth.currentUser!.uid);
    
  }
  @override
  void setState(VoidCallback fn) {
    _userStatusService.setRealtimeDatabaseStatus(_auth.currentUser!.uid);
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        
        child: Padding(
          padding: const EdgeInsets.only(top : 20, left: 20),
          child: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: Colors.amber,
            title: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ProfileScreen.ScreenRoute);
                        },
                    child: UserWidget(user : _auth.currentUser!.uid , userImageRaduis: 25, text: "Hello,",)),
          actions: [
           
           Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: (){
                   Navigator.pushNamed(context, NotificationScreen.screenRoute);
                },
                icon : const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF3D98FF),
                  size: 30,   
                  ) ,
              ),
            ),
            
          ],    
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text('Chats',style:TextStyle(fontSize: 35 , fontWeight: FontWeight.bold)),
          ),
          
          SizedBox(
            height:90 ,
            child: UserActiveWidget()),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left :30),
              child: FriendsScreen(),
            ))
          
        ],
      )
      
      
    );
  }
}