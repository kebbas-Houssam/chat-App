import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/MyButton.dart';
class WelcomeScreen extends StatefulWidget {

  static const String ScreenRoute = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 150,
                  child: Image.asset('images/image.png'),
                  ),
                Text('Message Me',style: TextStyle(fontSize: 40 ,fontWeight: FontWeight.w900 , color: Color.fromARGB(255, 187, 39, 135)),)
              ],
            ),
            SizedBox(
              height: 30,
            ),

            MyButton(color : Colors.amber[700]!,
            title:  'sign in ' ,
            onPressed:(){
              Navigator.pushNamed(context, LoginScreen.ScreenRoute);
            }
            ),

            MyButton(color: Colors.amber[700]!, 
            title: 'sign up', 
            onPressed: (){
              Navigator.pushNamed(context, SignupScreen.ScreenRoute);

            })
          ],
        ),
      ),
    );
  }
}

