// import 'dart:ffi';
// import 'dart:js_util';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserInformation {
//   final _firestore = FirebaseFirestore.instance; 
//  Future<bool> verifyUserStatus(String userId) async {
//   try {
//     DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();

//     if (snapshot.exists) {
//       final data = snapshot.data() as Map<String, dynamic>?;
//       if (data != null && data.containsKey('status')) {
//         final status = data['status'];

//         if ( status == 'online') return true;
//       }
//     }
    
//     return false;
//   } catch (e) {
//     print('Error verifying user status: $e');
//     return false;
//   }
// }



// }