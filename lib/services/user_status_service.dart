import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserStatusService {
  final DatabaseReference _userStatusRef = FirebaseDatabase.instance.ref().child('status');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setUserStatus(bool isOnline) {
    if (_auth.currentUser != null) {
      _userStatusRef.child(_auth.currentUser!.uid).set({
        'online': isOnline,
        'last_seen': ServerValue.timestamp,
      });
    }
  }

  void setupPresence() {
    FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
      if (event.snapshot.value == false) {
        return;
      }

      _userStatusRef.child(_auth.currentUser!.uid).onDisconnect().set({
        'online': false,
        'last_seen': ServerValue.timestamp,
      }).then((_) {
        setUserStatus(true);
      });
    });
  }
}