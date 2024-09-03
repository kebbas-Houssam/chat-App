import 'dart:io';
import 'package:chatapp/screens/groupDetails.dart';
import 'package:chatapp/services/audio_message_controlle.dart';
import 'package:chatapp/services/image_service.dart';
import 'package:chatapp/services/voice_message.dart';
import 'package:chatapp/widgets/group_Widget.dart';
import 'package:chatapp/widgets/message_Widget.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';


late AudioPlayer _audioPlayer;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {

  static const String ScreenRoute = 'chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  
  XFile? pickedImage ;
  String? messageText;
  
  @override
  void initState() {
    super.initState();
      
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    
    final Map <String , dynamic > data = ModalRoute.of(context)!.settings.arguments as Map <String , dynamic>;
    
    bool isGroupMessage = data['type'] == 'user' ? false : true;
  
    return Provider<Map <String ,dynamic> >(
      create : (context)=> data,
      
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(top : 20),
            child: AppBar(
              actions: [
                data['type'] == 'group' ?Padding(
                  padding: const EdgeInsets.only(right : 20),
                  child: GestureDetector(
                    onTap: (){
                        Navigator.pushNamed(context, Groupdetails.ScreenRoute ,
                        arguments: data['id'] != null 
                        ? data['id']
                        : null 
                  );
                    },
                    child: Icon(
                      Icons.info_sharp,
                      size : 25 ,
                      color: Color(0xff8074ec),
                      ),
                  ),
                )
                :SizedBox.shrink(),
              ],
              
              title: data['type'] == 'group' ? GroupWidget(group: data['id'] as String)
                                             : UserWidget(user: data['id'] as String, userImageRaduis: 25,text: '',),
                                            
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Text(data['id'] as String),
            MessageStreamBuilder(),
            Padding(
              padding: const EdgeInsets.only(bottom:30),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    
                    width: 0.6*(MediaQuery.of(context).size.width),
                    height: 50,
                      decoration: BoxDecoration(
                        
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                        
                     ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VoiceMessage(
                            sender: _auth.currentUser!.uid,
                            receiver: data['type'] == 'user' ? [data['id'] ] : data['members'], 
                            isGroupMessage: isGroupMessage, 
                            groupeId: data['id'] as String),
                            
                          IconButton(
                            onPressed: () async {
                                pickedImage = await pickImage();  
                            },
                            icon: Icon( 
                              Icons.attach_file_outlined,
                              color: Color(0xff604CD4),
                              size: 25,
                              )),

                          Expanded(
                              child: TextField(
                                controller: messageTextController,
                                onChanged: (value) {
                                messageText = value;
                              },
                            decoration: const InputDecoration(
                                contentPadding:
                                  EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  hintText: 'Message...',
                                  hintStyle: TextStyle(color: Color(0xff717171)),
                                  border: InputBorder.none),
                          )),     
                        ]
                      ),
                    ),
                   SizedBox(width: 15,),
                   Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(1), // Thickness of the border
                    decoration: BoxDecoration(
                      
                          borderRadius: BorderRadius.circular(15),
                              // shape: BoxShape.circle,
                          color: Color(0xff604CD4),),
                          child: IconButton(
                            onPressed: () async {
                              messageTextController.clear();
                              List receivers; 
                                
                             _firestore.collection('messages').add({
                                'sender': _auth.currentUser!.uid,
                                'text': pickedImage == null 
                                        ? messageText
                                        :await uploadImage(pickedImage! , 'messageImages'),
                                'type' : pickedImage == null 
                                         ? 'messageText' 
                                         : 'messageImage',       
                                'receiver' : data['type'] == 'user' ? [data['id']] : data['members'],
                                'time' : FieldValue.serverTimestamp() ,
                                'isGroupMessage' : isGroupMessage ,
                                'groupeId' : data['id'] ,
                              });
                            },
                            icon: Icon(
                              Icons.send_rounded,
                              color: Colors.white,),
                            ),
                   )
                ],
              ),
            ),

            ],
          ),
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<Map <String ,dynamic >>(context);

    return   StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('time').snapshots(), 
              builder: (context , snapshot){
                List <MessageLine> messagesWidgets = [];

                if (!snapshot.hasData){
                     return const Center(
                        child:CircularProgressIndicator() ,
                     );
                }
                final messages = snapshot.data!.docs.reversed;
                 
                  for ( var msg in messages){

                  final sender = _auth.currentUser!.uid;
                  late bool noRebuildMessage = true ;
                  List members = [];

                  if (data['type'] == 'user' ) {
                    members = [data['id']]  ;
                  } else 
                     members = data['members'];
                  
                  
                  final List receivers = msg.get('receiver');

                  for (var member in members){
                    if (receivers != null && receivers.isNotEmpty)
                    
                    for(var receiver in receivers ){
                    // if (sender != member )
                    
                    if (((sender == msg.get('sender') && member == receiver && noRebuildMessage) || ((sender == receiver && member == msg.get('sender')))) && (data['id'] == msg.get('groupeId')  || data['type'] == 'user')){
                    noRebuildMessage = false;
                    final text = msg.get('text');
                    final type = msg.get('type');
                    
                    final bool showMessage = ( msg.get('isGroupMessage') && data['type'] == 'group') 
                                            || (!msg.get('isGroupMessage') && data['type'] == 'user') ;
                    print(showMessage);
                    final messageWidget = MessageLine(text: text,isMe: sender == msg.get('sender') , showMessage: showMessage,type : type);
                    messagesWidgets.add(messageWidget);
                    }
                  }
                }
              }
                 return Expanded(
                   child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                    children: messagesWidgets,
                   ),
                 );
              },
              );
  }
}


