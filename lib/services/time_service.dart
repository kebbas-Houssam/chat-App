import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:intl/intl.dart';


class TimeService {
  
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
              lastSeenString = formatLastSeen(lastSeen.millisecondsSinceEpoch);
           
           }
        }    
    }
     return lastSeenString;
     
      }

    String formatLastSeen(int? timestamp) {
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


String formatMessageTime(int? timestamp) {
  if (timestamp == null) return 'Unknown';

  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();

  final yearDifference = now.year - dateTime.year;
  final weekDifference = now.difference(dateTime).inDays ~/ 7;
  final dayDifference = now.difference(dateTime).inDays;
  final hourDifference = now.difference(dateTime).inHours;
  final minuteDifference = now.difference(dateTime).inMinutes;

  if (yearDifference > 0) {
    return DateFormat('d MMM yyyy').format(dateTime); //  22 Jun 2022
  } else if (dayDifference >= 30) {
    return DateFormat('d MMM').format(dateTime); //  12Aug
  } else if (weekDifference > 0) {
    
    return DateFormat('EEE').format(dateTime); //Wed, Tue
  } else  return DateFormat('HH:mm').format(dateTime); //  21:34
  
}

String truncateText(String text, int length) {
  if (text.length > length) {
     String truncated =  text.substring(0, length) + '...';
     return   truncated ;
  } else {
    return text;
  }
}
}