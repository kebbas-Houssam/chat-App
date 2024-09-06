import 'package:chatapp/services/audio_message_controlle.dart';
import 'package:flutter/material.dart';

class MessageLine extends StatelessWidget {
  const MessageLine({required this.text  ,required this.isMe , super.key , required this.showMessage , required this.type});
  final String type;
  final String text;
  final bool isMe;
  final bool showMessage;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
            // Text(sender , style: TextStyle(color: Colors.grey[600] , fontSize: 12),),
            const SizedBox(height: 5,) ,
            showMessage
             ?type == 'messageImage'
              ?Image.network(
                  text, 
                  width: 100, 
                  height: 200
                )
              : Container(
                 constraints: BoxConstraints(
                   maxWidth: MediaQuery.of(context).size.width * 0.5, // زيادة العرض الأقصى
                 ),
                 child: Material(
                   elevation: 5,
                   color: isMe ? const Color(0xff8074ec) : const Color(0xff604cd4),
                   borderRadius: isMe
                       ? const BorderRadius.only(
                           topLeft: Radius.circular(15),
                           topRight: Radius.circular(15),
                           bottomLeft: Radius.circular(15),
                         )
                       : const BorderRadius.only(
                           topLeft: Radius.circular(15),
                           topRight: Radius.circular(15),
                           bottomRight: Radius.circular(15),
                         ),
                   child: Padding(
                     padding: type == 'messageText'
                         ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
                         : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                     child: type == 'messageText'
                         ? Text(
                             text,
                     style: const TextStyle(color: Colors.white, fontSize: 18),
                   )
                 : type == 'audio'
                     ? AudioMessageBubble(audioUrl: text)
                     : const SizedBox.shrink(),
              ),
           ),
        )
         :const SizedBox.shrink(),
        ],
      ),
    );
  }
} 
