import 'package:chatapp/screens/chats_screen.dart';
import 'package:chatapp/screens/groups_screen.dart';
import 'package:chatapp/screens/users_Screen.dart';
import 'package:chatapp/services/user_status_service.dart';
import 'package:flutter/material.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});
  static const String ScreenRoute = 'Navigationbar';

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  final UserStatusService _userStatusService = UserStatusService();

  int index = 0;
  final List<Widget> _pages = [
    ChatsScreen(),
    GroupsScreen(),
    UsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack( 
        children: [
       _pages[index],
       Positioned(
         left: 0,
         right: 0,
         bottom: 20,
         child: Center(
           child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 60,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
                 ),
                 child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, "CHAT", Icons.chat_bubble_outline, Icons.chat_bubble),
              _buildNavItem(1, "GROUPS", Icons.people_alt_outlined, Icons.people_alt),
              _buildNavItem(2, "SEARCH", Icons.search_outlined, Icons.search),
            ],
                 ),
                ),
         ),
       )]
      ));

  }

  Widget _buildNavItem(int idx, String label, IconData icon, IconData activeIcon) {
    final isSelected = index == idx;
    return GestureDetector(
      onTap: () => setState(() => index = idx),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? Colors.black : Color(0xFF9CA3AF),
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Color(0xFF9CA3AF),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}