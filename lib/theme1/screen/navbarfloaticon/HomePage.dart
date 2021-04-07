
import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/theme1/screen/navbarfloaticon/fab_bottom_app_bar.dart';
import 'package:hrm/theme1/screen/navbarfloaticon/fab_with_icons.dart';
import 'package:hrm/theme1/screen/navbarfloaticon/layout.dart';

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDChatScreen.dart';
import 'package:hrm/smartDeck/Screens/SDDashboardScreen.dart';
import 'package:hrm/smartDeck/Screens/SDLeaderBoardScreen.dart';
import 'package:hrm/smartDeck/Screens/SDProfileScreen.dart';
import 'package:hrm/smartDeck/Screens/SDScoreBoardScreen.dart';
import 'package:hrm/theme1/screen/T1AllHr.dart';
import 'package:hrm/theme1/screen/projects/T1AllProject.dart';
import 'package:hrm/theme1/screen/navbar1/T1Contact.dart';
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String _lastSelected = 'TAB: 0';
  int _currentIndex = 0;

  void _selectedTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    changeStatusColor(sdAppBackground);

    final tab = [
      SDDashboard(context),
      // T1Contact(),
      T1AllHr(),
      // T1AllProject(),
      SDChatScreen(),
      sdPRofileScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        body: tab[_currentIndex],
        bottomNavigationBar: FABBottomAppBar(
          backgroundColor: Colors.blue[900],
          centerItemText: 'Checkin',
          color: Colors.grey,
          selectedColor: sdSecondaryColorYellow,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
            FABBottomAppBarItem(iconData: Icons.layers, text: 'HR'),
            FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Project'),
            FABBottomAppBarItem(iconData: Icons.person, text: 'Acount'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFab(
            context), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.add, Icons.close ];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () { },
        tooltip: 'Increment',
        child: Icon(Icons.av_timer),
        elevation: 2.0,
      ),
    );
  }
}