import 'package:chatapp/screens/groupDetails.dart';
import 'package:chatapp/services/image_service.dart';
import 'package:chatapp/services/voice_message.dart';
import 'package:chatapp/widgets/group_Widget.dart';
import 'package:chatapp/widgets/message_Widget.dart';
import 'package:chatapp/widgets/user_Widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {

  // ignore: constant_identifier_names
  static const String ScreenRoute = 'chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final GlobalKey<_ChatScreenState> chatScreenKey = GlobalKey<_ChatScreenState>(); 
  final FocusNode _focusNode = FocusNode();
  
  XFile? pickedImage ;
  String? messageText;
  String? selectedMessageId;

  //   void _setMessageText(String text, String messageId) {
  //   setState(() {
  //     messageText = text;
  //     messageTextController.text = text;
  //     selectedMessageId = messageId;
  //   });
  //   _focusTextField();
  // }

  void _selectMessage(String messageId) {
    setState(() {
      selectedMessageId = messageId;
    });
    _focusTextField();
  }
  
  @override
  void initState() {
    super.initState();
      
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

 void _focusTextField() {
    _focusNode.requestFocus();
  }

  @override
    Widget build(BuildContext context) {
     

    
    final Map <String , dynamic > data = ModalRoute.of(context)!.settings.arguments as Map <String , dynamic>;
    
    bool isGroupMessage = data['type'] == 'user' ? false : true;
    List members = data['members'] ?? [];

    return Provider<Map <String ,dynamic> >(
      create : (context)=> data,
      
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(top : 20),
            child: AppBar(
              flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5)
              ),
            ),
              actions: [

                data['type'] == 'group' ?Padding(
                  padding: const EdgeInsets.only(right : 20),
                  child: GestureDetector(
                    onTap: (){
                        Navigator.pushNamed(context, Groupdetails.ScreenRoute ,
                        arguments: data['id'] 
                  );
                    },
                    child: const Icon(
                      Icons.info_sharp,
                      size : 25 ,
                      color: Colors.black,
                      ),
                  ),
                )
                :const SizedBox.shrink(),
              ],
              
              title: data['type'] == 'group' ? GroupWidget(group: data['id'] as String , text : '${members.length} members')
                                             : UserWidget(user: data['id'] as String, userImageRaduis: 25,text: data['lastSeen'] ),
                                            
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            MessageStreamBuilder(
              // focusTextField: _focusTextField
              //  setMessageText: _setMessageText,
                selectMessage: _selectMessage,
                selectedMessageId: selectedMessageId,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                        pickedImage = await pickImage();  
                    },
                    icon: const Icon( 
                      Icons.add_circle_outlined,
                      color: Colors.black,
                      size: 30,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: (MediaQuery.of(context).size.width)*0.6,
                      height: 50,
                        decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                          
                       ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            VoiceMessage(
                              sender: _auth.currentUser!.uid,
                              receiver: data['type'] == 'user' ? [data['id'] ] : data['members'], 
                              isGroupMessage: isGroupMessage, 
                              groupeId: data['id'] as String,
                              reply : selectedMessageId ?? ''),
                    
                            Expanded(
                                child: TextField(
                                  controller: messageTextController,
                                  focusNode: _focusNode,
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
                  ),
                   
                   IconButton(
                     onPressed: () async {
                       messageTextController.clear();
                       List receivers; 
                       if ((messageText!= null && messageText!.isNotEmpty  )||  pickedImage != null ) {
                         
                      _firestore.collection('messages').add({
                         'sender': _auth.currentUser!.uid,
                         'text': pickedImage == null 
                                 ? messageText
                                 : await uploadImage(pickedImage! , 'messageImages'),
                                 
                         'type' : pickedImage == null 
                                  ? 'messageText' 
                                  : 'messageImage',       
                         'receiver' : data['type'] == 'user' ? [data['id']] : data['members'],
                         'time' : FieldValue.serverTimestamp() ,
                         'isGroupMessage' : isGroupMessage ,
                         'groupeId' : data['id'] ,
                         'reactions' : [] ,
                         'reply' : selectedMessageId ?? '' ,
                       }).whenComplete((){
                          pickedImage = null;
                          messageText = null;
                       });
                       
                     
                    } else if (pickedImage == null){
                    
                    }
                       
                     },
                     icon: const Icon(
                       Icons.send_rounded,
                       color: Colors.black,
                       size : 30,),
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
  // final Function focusTextField;
  // final Function(String, String) setMessageText;
  final Function(String) selectMessage;
  final String? selectedMessageId;
  const MessageStreamBuilder({super.key , 
                              //  required this.focusTextField
                              // required this.setMessageText,
                              required this.selectMessage,
                              required this.selectedMessageId,
                              });
  
  @override
  Widget build(BuildContext context) {

    final data = Provider.of<Map <String ,dynamic >>(context);

    return   StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('time').snapshots(), 
              builder: (context , snapshot){
                List <MessageLine> messagesWidgets = [];
                

                if (!snapshot.hasData){
                     return const Center(
                        child:CircularProgressIndicator(),
                     );
                }
                
                final messages = snapshot.data!.docs.reversed;
                 
                  for ( var msg in messages){
                    
                  final sender = _auth.currentUser!.uid;
                  late bool noRebuildMessage = true ;
                  List members = [];
                 
                  if (data['type'] == 'user' ) {
                    members.add(data['id'])  ;
                  } else {
                    members .addAll(data['members']);
                  }

                  final List receivers = msg.get('receiver');

                  for (var member in members){
                    if (receivers.isNotEmpty){
                      
                      for(var receiver in receivers ){
                    

                    if (((sender == msg.get('sender') && member == receiver && noRebuildMessage) || ((sender == receiver && member == msg.get('sender')))) && (data['id'] == msg.get('groupeId')  || data['type'] == 'user')){
                    noRebuildMessage = false;
                    final messageId = msg.id;
                    final text = msg.get('text');
                    final type = msg.get('type');
                    final reply = msg.get('reply');
                    final reactions = msg.get('reactions') ?? []; 
                    print(' reaction is : $reactions'); 
                    
                    int time =  msg.get('time') != null ? msg.get('time').millisecondsSinceEpoch
                                                       : DateTime.now().millisecondsSinceEpoch ;
                    
                    final voiceMessageTime = type == 'audio' ?msg.get('voiceMessageTime') : '';           
                    final bool showMessage = ( msg.get('isGroupMessage') && data['type'] == 'group') 
                                            || (!msg.get('isGroupMessage') && data['type'] == 'user') ;
                    
                    final messageWidget = MessageLine(text: text,
                                                      isMe: sender == msg.get('sender'),
                                                      showMessage: showMessage,
                                                      type : type , 
                                                      time:  time ,
                                                      voiceMessageTime : voiceMessageTime ,
                                                      messageId : messageId,
                                                      userId: _auth.currentUser!.uid,
                                                      reactions : reactions,
                                                      reply : reply,
                                                      selectMessage: selectMessage,
                                                      isSelected: messageId == selectedMessageId,
                                                      );
                    messagesWidgets.add(messageWidget);
                    }
                  }
                }
              }
            }
                 return Expanded(
                   child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                    children: messagesWidgets,
                   ),
                 );
              },
              );
  }
}


