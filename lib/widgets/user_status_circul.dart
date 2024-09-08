import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class UserStatusCircul extends StatefulWidget {
  const UserStatusCircul({super.key , required this.userId , required this.userPictureRaduis});
  final String userId;
  final double userPictureRaduis;
  @override
  State<UserStatusCircul> createState() => _UserStatusCirculState();
}

class _UserStatusCirculState extends State<UserStatusCircul> {
  final _firestore =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(widget.userId).snapshots(),
      builder: (context , snapshot){
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //      return Sckelton2(raduis: 60,);
        // }

        if (snapshot.hasError) {
            return const Text('Something went wrong');
        }

        if (!snapshot.hasData ) {
          return const Text('No data found');
        }
        final data = snapshot.data ;
        final raduis = widget.userPictureRaduis;
        return
          Stack(
           clipBehavior: Clip.none,
           children: [
            CircleAvatar(
              radius : raduis,
              backgroundColor: Colors.grey.shade400,
              backgroundImage: NetworkImage(data!['profilePicture']),
              // child: (data!['profilePicture']== null && data!['profilePicture']== '') ? Icon(Icons.person,size: 22,color: Colors.grey,) : null
              ),
            Positioned(
              left: 0.5*(raduis)+raduis,
              top: 0.5*(raduis)+raduis,
              child: CircleAvatar(
                radius: 0.28*(raduis),
                backgroundColor: Color(0xFFF5F5F5),
                child: CircleAvatar(
                  radius: 0.22*(raduis),
                  backgroundColor: data['status'] == 'online' ? Colors.green : Colors.grey,
                ),
              ))
         ],
      );
      } ,
    );
  }
}