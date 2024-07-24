import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/widgets/MyButton.dart';
import 'package:chatapp/widgets/Navigationbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
    static const String ScreenRoute = 'signup_screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  
  late String email;
  late String password;
  late String name;
  bool spinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ModalProgressHUD(
        inAsyncCall: spinner,
        
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                child : Image.asset('images/image.png')
              ),
              SizedBox(height: 50,),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value){
                  name = value ;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey , width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red , width: 2),
                  ),
                  hintText: 'Your name',
                  contentPadding: EdgeInsets.symmetric(vertical: 10 , horizontal: 15)
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value){
                  email = value ;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey , width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red , width: 2),
                  ),
                  hintText: 'Your email',
                  contentPadding: EdgeInsets.symmetric(vertical: 10 , horizontal: 15)
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value){
                  password = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey , width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.red , width: 2),
                  ),
                  hintText: 'Your password',
                  contentPadding: EdgeInsets.symmetric(vertical: 10 , horizontal: 15)
                ),
              ),
              SizedBox(height: 20,),
              MyButton(
                color: Colors.deepOrange[400]!,
                title: 'Sign Up', 
                onPressed: () async{
                  // print(email + "/"+ password );
                  setState(() {
                      spinner = true;         
                  });
                  
                  try {
                    
                    
                    final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                    _firestore.collection('users').add({
                       'uid' : _auth.currentUser?.uid,
                       'name' : name,
                       'email' : email
                    });
                    Navigator.pushNamed(context, Navigationbar.ScreenRoute);
                    setState(() {
                      spinner = false;
                    });
                  } catch (e) {
                    print(e);
                  } 
                }
                )
        
            ],
          ),
        ),
      )
    );
  }
}