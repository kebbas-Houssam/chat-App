import 'package:chatapp/widgets/users_Widget.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  static const String screenRoute = 'Home_page';

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

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
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: UsersWidget(),      
        ),
      ),
    );
  }
}