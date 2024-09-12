import 'package:chatapp/screens/friends_screen.dart';
import 'package:chatapp/screens/notifications_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/services/user_status_service.dart';
import 'package:chatapp/widgets/shimmer.dart';
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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5)
              ),
            ),
            automaticallyImplyLeading: false,
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
                  Icons.notifications_rounded,
                  color: Colors.black,
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
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text('Chats',style:TextStyle(fontSize: 35 , fontWeight: FontWeight.bold)),
          ),
          
          SizedBox(
            height:90 ,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: UserActiveWidget(),
            )),
            
             
            const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left :20),
              child: FriendsScreen(),
            ))
          
        ],
      )
      
      
    );
  }
}
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    // رسم الأمواج الصوتية بشكل بسيط
    double spacing = 6.0;
    for (double i = 0; i < size.width; i += spacing) {
      double height = (i % (spacing * 4) == 0) ? size.height * 0.6 : size.height * 0.4;
      canvas.drawLine(Offset(i, size.height), Offset(i, size.height - height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // يتم إعادة الرسم للتأثير
  }
}



