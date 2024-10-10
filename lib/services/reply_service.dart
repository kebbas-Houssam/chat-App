import 'package:chatapp/widgets/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class ReplayService extends StatelessWidget {
  const ReplayService({super.key, required this.replyMessageId,});

  final String replyMessageId;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('messages').doc(replyMessageId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Sckelton(height: 25, width: 50);
        }
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(child: Text('Document does not exist'));
        }
    
        final data = snapshot.data!.data() as Map<String, dynamic>;
    
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            _getMessageContent(data),
            style: const TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  String _getMessageContent(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'messageText':
        return data['text'] ?? 'No text available';
      case 'messageImage':
        return 'Image message';
      case 'audio':
        return 'Audio message';
      default:
        return 'Unknown message type';
    }
  }
}