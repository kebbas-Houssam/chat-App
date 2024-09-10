import 'package:chatapp/services/audio_message_controlle.dart';
import 'package:chatapp/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TimeService _timeService = TimeService();
class MessageLine extends StatelessWidget {
  const MessageLine({required this.text  ,required this.isMe , super.key , required this.showMessage , required this.type , required this.time});
  final String type;
  final String text;
  final bool isMe;
  final bool showMessage;
  final int time;
  
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
                   maxWidth: MediaQuery.of(context).size.width * 0.75, // زيادة العرض الأقصى
                 ),
                 child: Material(
                  //  elevation: 1,
                   color: isMe ? const Color(0xffFFC107) : const Color(0xffc4c4c4),
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
                         ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
                         : const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                     child: type == 'messageText'
                         ? Column(
                           crossAxisAlignment: isMe ?CrossAxisAlignment.end : CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                               child: Text(text,
                                   style: const TextStyle(fontSize: 18),),
                             ),
     
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 3),
                               child: Text(_timeService.formatMessageTime(time),
                                    style: TextStyle(fontSize: 10 , fontWeight: FontWeight.w500 ),),
                             ),
                           ],
                         )
                 : type == 'audio'
                     ? Column(
                       crossAxisAlignment: isMe ?CrossAxisAlignment.end : CrossAxisAlignment.start,
                       children: [
                         AudioMessageBubble(audioUrl: text),
                         Text(_timeService.formatMessageTime(time),
                              style: TextStyle(fontSize: 10 , fontWeight: FontWeight.w500 ),),
                       ],
                     )
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
