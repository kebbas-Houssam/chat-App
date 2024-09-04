import 'package:chatapp/screens/edit_user_information.dart';
import 'package:chatapp/screens/welcome_screen.dart';
import 'package:chatapp/services/image_service.dart';
import 'package:chatapp/services/user_status_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String ScreenRoute = 'profile_screen';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  UserStatusService _userStatusService = UserStatusService();
  Future<DocumentSnapshot>? _userFuture;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
    void _loadUserData() {
    _userFuture = _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    
  }

 Future<Map<String, dynamic>> getUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data()!;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        actions: [
          
          PopupMenuButton(
            onSelected: (String results){
               switch(results){
                case 'logout' : 
                  _auth.signOut();
                  _userStatusService.updateUserStatus(_auth.currentUser!.uid, "offline");
                  Navigator.pushNamed(context, WelcomeScreen.ScreenRoute); 
                  break; 
                case 'edit Profile' :
                  Navigator.pushNamed(context, EditUser.ScreenRoute,
                  arguments: this._userFuture != null
                  ? this._userFuture 
                  : null   );
                  break;
               } 
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit Profile',
                child: Text('edite Profile'),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('lougout'),
              ),
            ],
          ),
          

        ],
        backgroundColor: Colors.redAccent[400],
        title: Text('Profile' , style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          children: [
            //add image 
            FutureBuilder<Map<String, dynamic>>(
              // future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(), 
              future: getUserData(), 
              builder: (context , snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                     return Center(child: CircularProgressIndicator(),);
                }else if (snapshot.hasError){
                  return Center(child: Text('ERROR : ${snapshot.error}'),);
                }else if (!snapshot.hasData ){
                  return Center(child : Text('user not found'));
                }else {
                  
                 Map<String, dynamic> userData = snapshot.data!;
                  
                  
                  String? imageUrl = userData['profilePicture'];
                  print(imageUrl);
                  return Center(
                    child: Column(
                      children: [

                        CircleAvatar(
                          radius:50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:  imageUrl != null && imageUrl.isNotEmpty 
                          ? NetworkImage(imageUrl)
                          : null ,
                          child: imageUrl == null || imageUrl.isEmpty 
                          ? Icon(Icons.account_circle ,
                                  size: 100,
                                  color: Colors.grey,)
                          : null         ,
                        ),
                        
                      SizedBox(height: 30,),
                      Center(
                        child : Text(
                          '${userData['name']}',
                          style: TextStyle(color: Colors.black , fontSize:35 ,),),
                      )
                      ],
                    ),
                  );
                }
              }
              ),
            IconButton(
              onPressed: (){
                pickAndUploadImage();
              } ,
              icon: Icon(Icons.add_a_photo)),
            
          ],
        ),
      ),
    );
  }
}