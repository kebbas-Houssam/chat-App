import 'package:chatapp/screens/friends_screen.dart';
import 'package:chatapp/screens/groups_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/screens/users_Screen.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _activeTabIndex = 0;
  PageController _pageController = PageController();

  void _setActiveTab(int index) {
    setState(() {
      _activeTabIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.only(top :20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Background color for tab bar
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabItem(0, 'Friends', _activeTabIndex == 0),
                  _buildTabItem(1, 'Groups', _activeTabIndex == 1),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _activeTabIndex = index;
                  });
                },
                children: [
                  FriendsScreen(), // Your AllPage widget
                  GroupsScreen(), // Your ActivePage widget
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, bool isActive) {
    return GestureDetector(
      onTap: () => _setActiveTab(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: isActive ? Color(0xff604CD4) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}