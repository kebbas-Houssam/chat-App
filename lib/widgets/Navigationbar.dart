import 'package:chatapp/screens/chats_screen.dart';
import 'package:chatapp/screens/groups_screen.dart';
import 'package:chatapp/screens/home_page.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});
  static const String ScreenRoute = 'Navigationbar';

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int index = 0 ;
    final List <Widget> _pages = [
    ChatsScreen(),
    GroupsScreen()
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) => setState(()=> this.index = index ),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.messenger_outline_outlined), 
            selectedIcon: Icon(Icons.messenger_rounded),
            label: "chat",
            ),
            NavigationDestination(
            icon: Icon(Icons.people_alt_outlined), 
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: "people",
            ),
          
        ],
      ),
      body: _pages[index],
    );
  }
}