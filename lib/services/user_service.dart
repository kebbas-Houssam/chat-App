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

Stream<Timestamp?> getLastMessageTimeStream(String uid) {
  return _firestore
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('lastmessagetime')) {
        return userData['lastmessagetime'] as Timestamp?;
      }
    }
    return null;
  });
}




Stream<List<String>> sortUsersByLastMessageTime(List<dynamic> userIds) async* {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  while (true) {
    List<Map<String, dynamic>> usersWithLastMessageTime = [];

    for (String uid in userIds) {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
      
      Timestamp lastMessageTime = Timestamp(0, 0);
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('lastmessagetime')) {
          lastMessageTime = userData['lastmessagetime'] as Timestamp;
        }
      }

      usersWithLastMessageTime.add({
        'uid': uid,
        'lastMessageTime': lastMessageTime,
      });
    }

    usersWithLastMessageTime.sort((a, b) {
      return (b['lastMessageTime'] as Timestamp).compareTo(a['lastMessageTime'] as Timestamp);
    });

    List<String> sortedUserIds = usersWithLastMessageTime.map((user) => user['uid'] as String).toList();

    yield sortedUserIds;

    // Wait for some time before the next update
    await Future.delayed(Duration(days: 1));
  }
}

// Usage with StreamBuilder

