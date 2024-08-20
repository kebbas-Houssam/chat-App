import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserGroup extends StatefulWidget {
  const AddUserGroup({super.key});
   static const String ScreenRoute = 'add_user_in_group';
  @override
  State<AddUserGroup> createState() => _AddUserGroupState();
  
}

class _AddUserGroupState extends State<AddUserGroup> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    
   final DocumentSnapshot snapshot = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
   final String id = snapshot.id;
   final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;


    return Provider<Map<String , dynamic>>(
      create: (context) => data,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: ()  {
                 late List newgroupMembers = data['members'];
                 newgroupMembers.addAll(_selectedUsers);
                 print(newgroupMembers); 
                 if (_selectedUsers.isNotEmpty) {
                  _firestore.collection('groups').doc(id).update(
                    {'members': newgroupMembers});
                  Navigator.pop(context);
                 }
              },
              icon : Icon(Icons.check)
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
      
                  if (snapshot.hasError) {
                    return Text('Something is wrong');
                  }
      
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No users found');
                  }
      
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data!.docs[index];
                      var username = user.get('name');
                      var userId = user.id;
                      var profilePicture = user.get('profilePicture');
                      
                      
                      
                        for ( var member in data['members'] ) {
                          if ( member['id'] == userId){
                          print(index);
                          return SizedBox.shrink();
                        }
                        }
                        
                          
                          Map<String, dynamic> userData = {
                           'id': userId,
                           'name': username,
                           'profilePicture': profilePicture,
                          };

                          return CheckboxListTile(
                          secondary: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: profilePicture != null ? NetworkImage(profilePicture) : null,
                              child: profilePicture == null || profilePicture.isEmpty
                              ? Icon(
                                  Icons.account_circle,
                                  size: 20,
                                )
                              : null,
                         ),
                        title: Text(username),
                        value: _selectedUsers.any((user) => user['id'] == userId),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null && value) {
                              _selectedUsers.add(userData);
                            } else {
                              _selectedUsers.removeWhere((user) => user['id'] == userId);
                            }
                          });
                        },
                      );
                        }
                       
                    
                  );
                },
              ),
        
      ),
    );
  }
}