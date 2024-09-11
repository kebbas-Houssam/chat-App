import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


  
  final _auth = FirebaseAuth.instance;
  final _firestore= FirebaseFirestore.instance;


  Future<XFile?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  return await picker.pickImage(source: ImageSource.gallery);
}
 //upload image to firebase storage
Future<String> uploadImage(XFile image , String path) async {
  File file = File(image.path);
  try {
    String fileName = '$path/${DateTime.now().millisecondsSinceEpoch}.png';//user_images
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  } catch (e) {
    print('Failed to upload image: $e');
    return '';
  }
}
 //message photo
  

 
//update user Image (database)
Future<void> updateUserProfile(String imageUrl) async {
  String userId = _auth.currentUser!.uid;
  await _firestore.collection('users').doc(userId).update({
    'profilePicture': imageUrl,
  });
}

void pickAndUploadImage() async {
  XFile? image = await pickImage();
  if (image != null) {
    String imageUrl = await uploadImage(image , 'user_images' );
    if (imageUrl.isNotEmpty) {
      await updateUserProfile(imageUrl);
      print('Profile picture updated successfully');
    }
  }
}

