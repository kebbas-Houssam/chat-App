import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _selectedUsers = [];
  late String title ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Group'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _createGroup,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                hintText: 'Group title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                    if (userId == _auth.currentUser!.uid) {
                      return SizedBox.shrink();
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createGroup() async {
    if (_selectedUsers.isNotEmpty) {
      DocumentReference groupRef = _firestore.collection('groups').doc();

      // إضافة بيانات المستخدم الحالي
      _selectedUsers.add({
        'id': _auth.currentUser!.uid,
        'name': _auth.currentUser!.displayName ?? 'Unnamed',
        'profilePicture': _auth.currentUser!.photoURL,
      });

      await groupRef.set({
        'title': title,
        'members': _selectedUsers,
        'createdBy': _auth.currentUser!.uid,
        'createdAt': Timestamp.now(),
      });

      Navigator.pop(context);
    }
  }
}
