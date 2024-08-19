import 'package:chatapp/screens/chats_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Groupdetails extends StatefulWidget {
  const Groupdetails({super.key});
  static const String ScreenRoute = 'groupDetails';
  @override
  State<Groupdetails> createState() => _GroupdetailsState();
}

class _GroupdetailsState extends State<Groupdetails> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final String data  = ModalRoute.of(context)!.settings.arguments as String;

    return Provider<String>(
      create : (context)=> data,
      child: Scaffold(
        appBar: AppBar(
          title: Text('group detail'),
        ),
        body: FutureBuilder(
          future : _firestore.collection('groups').doc(data).get(),
          builder: (context , snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('User data not found'));
                  } else {
                    final groupInformation = snapshot!.data;
                    final List groupMembers = groupInformation!['members'];
                    return Column(
                      
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top : 50),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  
                                  child:CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(groupInformation!['members'][0]['profilePicture']),
                                  ) 
                                  ),
                                  Positioned(
                                  bottom:15,
                                  left: 25,
                                  child:CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(groupInformation!['members'][1]['profilePicture']),
                                  ) 
                                  ),
                              ],
                            ),
                          ),
                          
                        ),
                        SizedBox(height: 20),
                        Text(
                          groupInformation!['title'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize : 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed:(){

                              },
                              icon: Icon(Icons.person_add),
                              ),
                              SizedBox(width: 20,),
                              IconButton(
                              onPressed:(){
                                for ( int i = 0; i < groupMembers.length; i++){
                                  var member = groupMembers[i];
                                  if (member['id'] == _auth.currentUser!.uid)
                                  {
                                    groupMembers.remove(member);
                                    _firestore.collection('groups').doc(data).update(
                                      {
                                      'members' : groupMembers  
                                      }
                                    );
                                    Navigator.pushNamed(context, ChatsScreen.ScreenRoute);
                                  }
                                }
                              },
                              icon: Icon(Icons.logout),
                              ),
                              
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text('Members'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: groupMembers.length,
                            itemBuilder: (context , index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child : Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(groupMembers[index]!['profilePicture']),
                                        ),
                                        SizedBox(width: 20,),
                                        Text(groupMembers[index]['name'])
                                      ],
                                    ),
                                  )
                                ),
                              );
                            }
                            ),
                        ),
                      ],
                    );
                  }
            
          },
        

        ),
          ),
        );
 
  }
}