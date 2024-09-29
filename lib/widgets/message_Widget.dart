import 'dart:ffi';

import 'package:chatapp/services/audio_message_controlle.dart';
import 'package:chatapp/services/fullScreenImage.dart';
import 'package:chatapp/services/message_reaction.dart';
import 'package:chatapp/services/reply_service.dart';
import 'package:chatapp/services/time_service.dart';
import 'package:chatapp/widgets/reaction_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

final _firestore = FirebaseFirestore.instance;
TimeService _timeService = TimeService();
class MessageLine extends StatelessWidget {
  const MessageLine({super.key , 
                     required this.text,
                     required this.isMe , 
                     required this.showMessage , 
                     required this.type , 
                     required this.time,
                     required this.voiceMessageTime,
                     required this.messageId,
                     required this.userId ,
                     required this.reactions,
                     required this.selectMessage,
                     required this.isSelected,
                     required this.reply,
                     });
  final String type , voiceMessageTime , text , messageId,userId , reply;
  final bool isMe , showMessage, isSelected;
  final int time;
  final List reactions;
  
  final Function(String) selectMessage;
  
  
  @override
  Widget build(BuildContext context) {
    // print(reaction['reaction']);
   MessageReaction messageReaction = MessageReaction();

    return Dismissible(
      key: Key(messageId),
      direction: DismissDirection.horizontal,
      background: Container(
        color: const Color(0xFFF5F5F5),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:  EdgeInsets.only(left: 50),
            child: Icon(Icons.reply, color: Colors.black),
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
      
          selectMessage(messageId);
        
        return false; 
      },
      
      child: GestureDetector(
        onLongPress: (){
         messageReaction.showEmojiOptions(context, messageId , userId , reactions);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: isMe? Alignment.centerRight : Alignment.centerLeft,
            child: Wrap(
              children: [
              Stack(
                clipBehavior: Clip.none,
                // alignment: isMe? Alignment.centerRight : Alignment.centerLeft,
                children: [
                Column(
                  crossAxisAlignment:isMe?  CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 5,) ,
                  reply != ''  ? ReplayService(replyMessageId: reply) 
                               : const SizedBox.shrink(),

                    Column(
                  crossAxisAlignment:isMe?  CrossAxisAlignment.end : CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,
                          children: [  
                          showMessage
                           ?type == 'messageImage'
                            ?Stack(
                              children: [
                              GestureDetector(
                                  onTap: () {
                                  Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => FullScreenImage(imageUrl: text),
                                     ),
                                   );
                                 },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 260, // الحد الأقصى للعرض
                                      maxHeight: 250, 
                                    ),
                                    child: Image.network(
                                        text, 
                                        fit: BoxFit.contain,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                              height: 250,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.1)
                                              ),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            ); 
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Text('erro in loading image');
                                        },
                                      ),
                                  ),
                                ),
                              ),
                              isMe 
                              ?Positioned(
                                bottom:5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                                      child: Text(_timeService.formatMessageTime(time),
                                                  style: const TextStyle(fontSize: 10 , fontWeight: FontWeight.w600 ),),
                                    ),
                                  ), 
                                )
                                )
                                :Positioned(
                                bottom:5,
                                left: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(Radius.circular(8))
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                                      child: Text(_timeService.formatMessageTime(time),
                                                  style: const TextStyle(fontSize: 10 , fontWeight: FontWeight.w600 ),),
                                    ),
                                  ), 
                                )
                                )
                              ],
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
                                                  style: const TextStyle(fontSize: 10 , fontWeight: FontWeight.w500 ),),
                                           ),
                                         ],
                                       )
                               : type == 'audio'
                                   ? Column(
                                     crossAxisAlignment: isMe ?CrossAxisAlignment.end : CrossAxisAlignment.start,
                                     children: [
                                       AudioMessageBubble(audioUrl: text ,voiceMessageTime: voiceMessageTime),
                                       Text(
                                          _timeService.formatMessageTime(time),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                        ),
                                     ],
                                   )
                                   : const SizedBox.shrink(),
                                             ),
                                          ),
                      )
                       :const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                Positioned(
                      left: isMe ? -15 : null,
                      right: isMe ? null : -15,
                      bottom: -10,
                      child: ReactionWidget(reactions: reactions,)
                      )
                ],
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }
} 
