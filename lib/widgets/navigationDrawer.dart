

import 'package:flutter/material.dart';

class Navigationdrawer extends StatelessWidget {
  const Navigationdrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
            // buildHeader(context),
            // buildMenuItems(context),   
        ],

      ),
    ),
  );
  // Widget buildHeader(BuildContext context)=> Container();
  // Widget buildMenuItems(BuildContext context)=> Container();

  }