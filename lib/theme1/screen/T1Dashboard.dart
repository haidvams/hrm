import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrm/theme1/screen/navbar1/MBHome.dart';
import 'package:hrm/theme1/screen/navbar1/NotificationScreen.dart';
import 'package:hrm/theme1/screen/navbar1/ProfileNavBar.dart';
import 'package:hrm/theme1/screen/navbar1/T1Contact.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Extension.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';
import 'package:hrm/theme1/utils/T2BubbleBotoomBar.dart';

class T1Dashboard extends StatefulWidget {
  static var tag = "/T1Dashboard";

  @override
  State<StatefulWidget> createState() {
    return T1DashboardState();
  }
}

class T1DashboardState extends State<T1Dashboard> {
  var isSelected = 1;
  var width;
  var height;
  var currentIndex = 0;
  final List<Widget> _bodyContent = [
    DashBoardHome(),
    T1Contact(),
    NotificationScreen(),
    ProfileNavBar(),
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    changeStatusColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: t1_white,
      body: _bodyContent[currentIndex],
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        onTap: changePage,
        //new
        hasNotch: false,
        //new
        hasInk: true,
        //new, gives a cute ink effect
        inkColor: t1_colorPrimary,
        //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          tab(Icons.home, t1_lbl_home),
          tab(Icons.contact_phone, t1_lbl_contacts),
          tab(Icons.notifications_none, t1_lbl_notification),
          tab(Icons.person, t1_lbl_profile),
        ],
      ),

    );
  }

  Widget tabItem(var pos, var icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = pos;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        alignment: Alignment.center,
        decoration: isSelected == pos
            ? BoxDecoration(
                shape: BoxShape.circle, color: t1_colorPrimary_light)
            : BoxDecoration(),
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          color: isSelected == pos ? t1_colorPrimary : t1_textColorSecondary,
        ),
      ),
    );
  }

  Widget mediaButton(String buttonText, String icon) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: t1_color_primary_light),
          width: width / 5.5,
          height: width / 5.5,
          padding: EdgeInsets.all(width / 18),
          child: SvgPicture.asset(
            icon,
            color: t1_colorPrimary,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        text(buttonText,
            textColor: t1TextColorPrimary,
            fontSize: textSizeMedium,
            fontFamily: fontMedium)
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

}


