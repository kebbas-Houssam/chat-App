import 'package:chatapp/screens/profile_screen.dart';
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
            title: FutureBuilder<Map<String, dynamic>>(
          
            future: getUserData(_auth.currentUser!.uid),
            builder: (context, snapshot) {
          
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('User data not found'));
              } else {
                Map<String, dynamic> userData = snapshot.data!;
                String? imageUrl = userData['profilePicture'];
          
                return 
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        
                        padding: EdgeInsets.all(3), // Thickness of the border
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff604CD4),), 
                        
                        // Border color
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, ProfileScreen.ScreenRoute);
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                             ? NetworkImage(imageUrl) 
                             : null,
                            child: imageUrl == null || imageUrl.isEmpty
                                ? Icon(
                                    Icons.account_circle,
                                    size: 20,
                                    // color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),

                      Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello ,' , style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),),
                          
                          Text(
                            '${userData['name'] ?? 'User'}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                               fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                     );
                
              }
            },
          ),
          actions: [
            Icon(
                Icons.search ,
                color: Color(0xFF604CD4),
                size: 30,
              ),
              SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.menu_outlined ,
                color: Color(0xFF604CD4),
                size: 30,
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