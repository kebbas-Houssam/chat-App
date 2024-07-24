import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';



final _firestore = FirebaseFirestore.instance;
late User signInUser;


class ChatScreen extends StatefulWidget {

  static const String ScreenRoute = 'chat_screen';

  // const ChatScreen({super.key, required String data});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;
  
  
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        signInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var msg in messages.docs) {
      print(msg.data());
    }
  }

  // void getMessagesStreams() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var msg in snapshot.docs) {
  //       print(msg.data());
  //     }
  //   }
  // }
  late String data ;
  @override
  Widget build(BuildContext context) {
    
    final args = ModalRoute.of(context)?.settings.arguments ;
    if (args is String) {
      data = args;
    } else {
      data = 'Default Value'; 
    }
    return Provider<String>(
      create : (context)=> data ,
      child: Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.redAccent[400]!,
          title: Row(
            children: [
              Container(
                height: 32,
                child: Image.asset('images/image.png'),
              ),
              SizedBox(
                width: 15,
              ),
              Text('Chat Screen ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  )),
            ],
          ),
          actions: [
            
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Text(data),
            MessageStreamBuilder(),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                  color: Colors.redAccent[400]!,
                  width: 2,
                ))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          hintText: 'your message here...',
                          border: InputBorder.none),
                    )),
                    TextButton(
                        onPressed: () {
                          messageTextController.clear();
                         _firestore.collection('messages').add({
                            'sender': signInUser.uid,
                            'text': messageText,
                            'receiver' : data,
                            'time' : FieldValue.serverTimestamp() ,
                          });
                        },
                        child: Text(
                          'send',
                          style: TextStyle(
                            color: Colors.orange[700]!,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
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
    final data = Provider.of<String>(context);
    return   StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('time').snapshots(), 
              builder: (context , snapshot){
                List <MessageLine> messagesWidgets = [];

                if (!snapshot.hasData){
                     return Center(
                        child:CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ) ,
                     );
                }
                final messages = snapshot.data!.docs.reversed;

                for ( var msg in messages){
                  final sender = signInUser.uid;
                  final receiver = data ;

                  if ((sender == msg.get('sender') && receiver == msg.get('receiver')) || ((sender == msg.get('receiver') && receiver == msg.get('sender')))){
                    final text = msg.get('text');
                    final messageWidget = MessageLine(text: text,isMe: sender == msg.get('sender') ,);
                    messagesWidgets.add(messageWidget);
                  }
                  // final sender = msg.get('sender');
                  // final receiver = msg.get('receiver');
                  // final currentUser = signInUser.uid;
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


class MessageLine extends StatelessWidget {
  const MessageLine({required this.text  ,required this.isMe , super.key});
  
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(sender , style: TextStyle(color: Colors.grey[600] , fontSize: 12),),
          SizedBox(height: 5,) ,
          Material(
            elevation: 5 ,
            color: isMe? Colors.red[400] : Color.fromARGB(255, 226, 128, 7),
            borderRadius:isMe? BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ) : BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20 , vertical: 15),
              child: Text('$text' , style: TextStyle(color: Colors.white),),
            )
            ),
        ],
      ),
    );
  }
} 
