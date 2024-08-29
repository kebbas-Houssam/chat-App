import 'package:chatapp/widgets/user_Widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static const String screenRoute = 'NotificationScreen';


  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (!snapshot.hasData) {
            return const Text('No notification found');
          }

          Map<String, dynamic>? user = snapshot.data!.data() as Map<String, dynamic>?;

          final List friendRequest = user?['fiendReduest'] ?? [];
          List friends = List.from(user?['friends'] ?? []);
          List<Widget> friendRequests = [];

          if (friendRequest.isNotEmpty) {
            for (var request in friendRequest) {
              friendRequests.add(
                Row(
                  children: [
                    UserWidget(user: request),
                    SizedBox(width: 50),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          friends.add(request);
                          friendRequest.remove(request);
                          _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                            'friends': friends,
                            'fiendReduest': friendRequest,
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.how_to_reg,
                        color: Color(0xFF604CD4),
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          friendRequest.remove(request);
                          _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                            'fiendReduest': friendRequest,
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF604CD4),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          return ListView(
            children: friendRequests,
          );
        },
      ),
    );
  }
}
