import 'package:chatapp/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetMessage {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TimeService _timeService = TimeService();
  Stream<dynamic> getLastMessage(String sender, String receiver, String groupeId) {
  return _firestore
      .collection('messages')
      .orderBy('time', descending: true)
      .snapshots()
      .map((snapshot) {

    if (snapshot.docs.isEmpty) {
      return 'no data';
    }

    for (var msg in snapshot.docs) {
      Map<String, dynamic> data = msg.data() as Map<String, dynamic>;
      String messageSender = data['sender'];
      List<dynamic> messageReceivers = data['receiver'];
      Timestamp messageTime = data['time'];
      String messageGroupId = data['groupeId'];
      String time = _timeService.formatMessageTime(messageTime.millisecondsSinceEpoch);
      if (((messageSender == sender && messageReceivers.contains(receiver)) ||
          (messageSender == receiver && messageReceivers.contains(sender))) && (messageGroupId == groupeId))  {
        String messageType = data['type'];
        switch (messageType) {
          case 'messageText':
            return {
                  'newGroupe' : false,
                  'time' : messageTime,
                  'text': messageSender == _auth.currentUser!.uid ? "You: ${_timeService.truncateText(data['text'], 20)}  .$time" 
                                                                  : "${_timeService.truncateText(data['text'], 20)}  .$time"  };
          case 'messageImage':
            return {
                'newGroupe' : false,
                 'time' : messageTime,
                 'text' : messageSender == _auth.currentUser!.uid ? "You: image   .$time"  : ' image  .$time' 
               }; 
          case 'audio':
               return {
                  'newGroupe' : false,
                  'time' : messageTime,
                  'text' : messageSender == _auth.currentUser!.uid ? "You: message vocale   .$time"  : ' message vocale  .$time'
               } ;
          default:
            return {
              // 'time' : '',
              'newGroupe' : false,
              'text' : 'message'
            };
        }
      }
      
    }
    return {
      // 'time' : '',
      'newGroupe' : true,
      'text' : 'say hi!',
    };
  });
}
  
}