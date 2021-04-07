import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDDashboardScreen.dart';
import 'package:hrm/smartDeck/Screens/SDLeaderBoardScreen.dart';
import 'package:hrm/smartDeck/Screens/SDProfileScreen.dart';
import 'package:hrm/smartDeck/Screens/SDScoreBoardScreen.dart';
import 'package:hrm/theme1/screen/T1AllHr.dart';
import 'package:hrm/theme1/screen/projects/T1AllProject.dart';
import 'package:hrm/theme1/screen/navbar1/T1Contact.dart';
import 'package:hrm/theme1/screen/chatroom/ChatScreenMain.dart';

class SDHomePageScreen extends StatefulWidget {
  @override
  _SDHomePageScreenState createState() => _SDHomePageScreenState();
}

class _SDHomePageScreenState extends State<SDHomePageScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    changeStatusColor(sdAppBackground);
    final tab = [
      SDDashboard(context),
      // T1Contact(),
      T1AllHr(),
      T1AllProject(),
      ChatScreenMain(),
      sdPRofileScreen(),
    ];

    return SafeArea(
      child: Scaffold(
          backgroundColor: sdAppBackground,
          body: tab[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: sdShadowColor, spreadRadius: 0, blurRadius: 2)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset('images/smartDeck/images/sdhome.png',
                        height: 28, width: 28, color: sdIconColor),
                    activeIcon: Image.asset(
                        'images/smartDeck/images/sdhome.png',
                        height: 28,
                        width: 28,
                        color: sdPrimaryColor),
                    title: Text('a'),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('images/smartDeck/images/sdexamcard.png',
                        height: 28, width: 28, color: sdIconColor),
                    activeIcon: Image.asset(
                        'images/smartDeck/images/sdexamcard.png',
                        height: 28,
                        width: 28,
                        color: sdPrimaryColor),
                    title: Text('a'),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('images/smartDeck/images/sdleaderboard.png', height: 28, width: 28, color: sdIconColor),
                    activeIcon: Image.asset('images/smartDeck/images/sdleaderboard.png', height: 28, width: 28, color: sdPrimaryColor),
                    title: Text('a'),
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Image.asset('images/smartDeck/images/sdchats.png',
                            height: 28, width: 28, color: sdIconColor),
                        Positioned(
                          top: -2,
                          right: -6,
                          child: CircleAvatar(
                              radius: 3, backgroundColor: sdSecondaryColorRed),
                        )
                      ],
                    ),
                    activeIcon: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Image.asset('images/smartDeck/images/sdchats.png',
                            height: 28, width: 28, color: sdPrimaryColor),
                        Positioned(
                          top: -2,
                          right: -6,
                          child: CircleAvatar(
                              radius: 3, backgroundColor: sdSecondaryColorRed),
                        )
                      ],
                    ),
                    title: Text('a'),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                            "images/theme1/icons8-more_info_skin_type_7.png",
                            fit: BoxFit.cover,
                            height: 35,
                            width: 10),
                      ),
                    ),
                    activeIcon: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: sdPrimaryColor, width: 2)),
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "images/theme1/icons8-more_info_skin_type_7.png",
                          fit: BoxFit.cover,
                          height: 35,
                          width: 10,
                        ),
                      ),
                    ),
                    title: Text('a'),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          ),
    );
  }


}
