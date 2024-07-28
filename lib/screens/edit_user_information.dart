import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});
  static const String ScreenRoute = 'edit_user_information';

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;
    return Provider(
      create: (context) => data,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Your Information',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.redAccent[400],
        ),
        body: Center(
          child: Column(
            children: [
              
              
            
              SizedBox(height: 50,),
              Icon(Icons.edit)
            ],
          ),
        ),
      ),
    );
  }
}