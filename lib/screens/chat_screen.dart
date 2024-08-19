import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/screens/welcome_screen.dart';
import 'package:chatapp/services/user_service.dart';
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

  Future<String?> getProfileImage(String userId) async {
  try {
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(userId).get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      return documentSnapshot.get('profilePicture') as String?;
    } else {
      return null; // في حالة عدم وجود صورة
    }
  } catch (e) {
    print('Error fetching profile image: $e');
    return null; // في حالة حدوث خطأ
  }
}
  
  
  @override
  Widget build(BuildContext context) {
    
    final List<dynamic> args = ModalRoute.of(context)!.settings.arguments as List <dynamic>;

    List <dynamic> data = [];

    if (args is List) {
      data = args;  
    } else {
      data = []; 
    }
    List <String> members = [];
                  if (data.length==1 ) members.add(data[0]);
                  else for (int i = 1; i < data.length; i++ ){
                    members.add(data[i]['id']);}

    //  final Future<String?> ImageUser = getProfileImage(_auth.currentUser!.uid);
  
  
    return Provider<List<dynamic>>(
      create : (context)=> data,
      
      child: Scaffold(
        // backgroundColor: Colors.white ,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(top : 20),
            child: AppBar(
              
              // backgroundColor: Colors.redAccent[400]!,
              title: FutureBuilder(
                
                future: data.length == 1
                ? _firestore.collection('users').doc(data[0]).get()
                : _firestore.collection('groups').doc(data[0]).get(), 
                builder: (context, snapshot) {
              
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('User data not found'));
                  } else {
                   
                    dynamic datas = snapshot.data!;
                    // String? imageUrl = userData['profilePicture'];
              
                    return 
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          Container(
                            padding: EdgeInsets.all(3), // Thickness of the border
                            decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Color(0xff604CD4)
                            ), // Border color
                            child: CircleAvatar(
                               radius: data.length == 1 ? 20 : 15,
                               backgroundColor: Colors.grey[300],
                               backgroundImage: data.length == 1 && datas['profilePicture'] != null 
                               ? NetworkImage(datas['profilePicture'])
                               : NetworkImage(datas['members'][0]['profilePicture']),
                               
                               child: data.length == 1 && datas['profilePicture'] == null
                               ? Icon(
                                     Icons.account_circle,
                                     size: 20,
                               )              
                               : data.length >= 2 
                               ?  Stack(
                                   clipBehavior: Clip.none,
                                   children: [
                                     Positioned(
                                        left: 20,
                                        bottom: 5,
                                        child: Container(
                                          padding: EdgeInsets.all(3), // Thickness of the border
                                          decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // color: Colors.white
                                          ),

                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: NetworkImage(datas['members'][1]['profilePicture']),
                                          ),
                                        )
                                    ),
                                ]
                                    )
                                : null
                                
                          
                            )

                          ),
                          data.length ==1
                          ? SizedBox(width: 20,)
                          :SizedBox(width: 40,),
                       
                          Column(
                            
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( data.length == 1 
                                ?'${datas['name'] ?? 'User'}'
                                :'${datas['title']  }',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                   fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                         );
                    
                    
                  
                      }
             },
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Text(data[0]),
            MessageStreamBuilder(),
            // message box
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
                          IconButton(
                            onPressed: (){},
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
                            decoration: InputDecoration(
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
                            onPressed: () {
                              messageTextController.clear();
                                List receivers; 
                                bool isGroupMessage = data.length == 1 ? false : true;
                             _firestore.collection('messages').add({
                                'sender': signInUser.uid,
                                'text': messageText,
                                'receiver' : members ,//user id 
                                'time' : FieldValue.serverTimestamp() ,
                                'isGroupMessage' : isGroupMessage ,
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
    final data = Provider.of<List>(context);
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
                  List members = [];
                  late bool noRebuildMessage = true ;

                  if (data.length==1 ) members = data ;
                  else for (int i = 1; i < data.length; i++ ){
                    members.add(data[i]['id']);
                  }
                  
                  final List receivers = msg.get('receiver');
                  for (var member in members){
                    if (receivers != null && receivers.isNotEmpty)
                    for(var receiver in receivers ){

                      if (sender != member ) 
                    if ((sender == msg.get('sender') && member == receiver && noRebuildMessage) || ((sender == receiver && member == msg.get('sender')))){
                    noRebuildMessage = false;
                    final text = msg.get('text');

                    final bool showMessage = (msg.get('isGroupMessage')== true && data.length>=2) 
                                            || (msg.get('isGroupMessage') == false  && data.length==1) ;
                    final messageWidget = MessageLine(text: text,isMe: sender == msg.get('sender') , showMessage: showMessage,);
                    messagesWidgets.add(messageWidget);
                    
                    }
                    // break;
                  }
                  
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
  const MessageLine({required this.text  ,required this.isMe , super.key , required this.showMessage });
  
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
          SizedBox(height: 5,) ,
          showMessage
          ? Material(
            elevation: 5 ,
            color: isMe? Color(0xff8074ec) : Color(0xff604cd4),
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
            )
            :SizedBox.shrink(),
        ],
      ),
    );
  }
} 
