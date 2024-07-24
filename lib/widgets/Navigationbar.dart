import 'package:chatapp/screens/chats_screen.dart';
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
    HomePage(),
    ProfileScreen()
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (index) => setState(()=> this.index = index ),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.messenger_rounded), 
            selectedIcon: Icon(Icons.messenger_rounded),
            label: "chat",
            ),
            NavigationDestination(
            icon: Icon(Icons.people_alt_outlined), 
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: "people",
            ),
            NavigationDestination(
            icon: Icon(Icons.person_2_outlined), 
            selectedIcon: Icon(Icons.person_2_rounded),
            label: "profile",
            ),
        ],
      ),
      body: _pages[index],
    );
  }
}