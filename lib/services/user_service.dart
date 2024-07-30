import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<Map<String, dynamic>> getUserData(String userID) async {
   final String Id = userID; 
  try {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('users')
        .doc(Id)
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