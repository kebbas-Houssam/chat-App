import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserStatusService {
  final DatabaseReference _userStatusRef = FirebaseDatabase.instance.ref().child('status');
  final FirebaseAuth _auth = FirebaseAuth.instance;

 Future<void> updateUserStatus(String userId, String status) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  await userRef.update({
    'status': status,
    'lastSeen': FieldValue.serverTimestamp(), // تحديث آخر ظهور
  });
}

void setOnlineStatus(String userId) {
  updateUserStatus(userId, 'online');
}

void setOfflineStatus(String userId) {
  updateUserStatus(userId, 'offline');
}

Future<void> setRealtimeDatabaseStatus(String userId) async {
  try {
    // Ensure Firebase is initialized
    await Firebase.initializeApp();

    // Check if user is authenticated (if required by your rules)
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not authenticated");
      return;
    }

    final userStatusDatabaseRef = FirebaseDatabase.instance.ref('/status/$userId');
    
    // Set the status
    await userStatusDatabaseRef.set('online');
    
    // Set up onDisconnect
    await userStatusDatabaseRef.onDisconnect().set('offline');
    
    print("Status set successfully. Path: ${userStatusDatabaseRef.path}");

    // Verify the data was written
    final snapshot = await userStatusDatabaseRef.get();
    print("Current value: ${snapshot.value}");
  } catch (e) {
    print("Error setting status: $e");
  }
}






}