import 'package:cloud_firestore/cloud_firestore.dart';

class GetLastSeen {
  
  final _firestore = FirebaseFirestore.instance;

   Future<String> getLastseen(String userId )async {
    String lastSeenString = ''  ;
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
    if (snapshot.exists){
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.isNotEmpty){
           if (data!['status'] == 'online') lastSeenString = 'Active Now';
           else {
           
             Timestamp lastSeen = data!['lastSeen'];
              lastSeenString = _formatLastSeen(lastSeen.millisecondsSinceEpoch);
           
           }
        }    
    }
     return lastSeenString;
     
      }

    String _formatLastSeen(int? timestamp) {
      if (timestamp == null) return 'Unknown';
      
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
    
      final yearDifference = now.year - dateTime.year;
      final monthDifference = now.month - dateTime.month;
      final dayDifference = now.difference(dateTime).inDays;
      final hourDifference = now.difference(dateTime).inHours;
      final minuteDifference = now.difference(dateTime).inMinutes;
    
      if (yearDifference > 0) {
        return yearDifference == 1 ? '1 year ago' : '$yearDifference years ago';
      } else if (monthDifference > 0) {
        return monthDifference == 1 ? '1 month ago' : '$monthDifference months ago';
      } else if (dayDifference > 0) {
        return '$dayDifference d ago';
      } else if (hourDifference > 0) {
        return '$hourDifference h ago';
      } else if (minuteDifference > 0) {
        return '$minuteDifference m ago';
      } else {
        return 'Just now';
    }
  }
  
}