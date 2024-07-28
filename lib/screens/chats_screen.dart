import 'package:chatapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/customTabBar.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});
  static const String ScreenRoute = 'chats_screen';

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}
Future<Map<String, dynamic>> userData = getUserData();


  
class _ChatsScreenState extends State<ChatsScreen> {
  
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
          
            future: getUserData(),
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
                        color: Color(0xff604CD4),), // Border color
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                          child: imageUrl == null
                              ? Icon(
                                  Icons.account_circle,
                                  size: 20,
                                  // color: Colors.grey,
                                )
                              : null,
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