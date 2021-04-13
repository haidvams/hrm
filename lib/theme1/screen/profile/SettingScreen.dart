import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  var db = new DatabaseHelper();

  Preferences(){

  }
  PrivacyandSecurity(){

  }
  NotificationSettings(){

  }
  HelpCenter(){

  }
  Logout() async {
    await db.deleteUsers();
    Navigator.of(context).pushReplacementNamed("/T1Login");
  }

  @override
  Widget build(BuildContext context) {
    Widget mOption(var icon, var heading, final action) {
      return ListTile(
        onTap: action,
        leading: Icon(
          icon,
          color: sdIconColor,
          size: 18,
        ),
        title: Text(
          heading,
          style: primaryTextStyle(size: 16, textColor: sdTextPrimaryColor),
        ),
        trailing: Container(
          child: Icon(
            Icons.keyboard_arrow_right,
            color: sdIconColor,
          ),
        ),
      );
    }


    Widget mDivider() {
      return Container(
        color: sdViewColor,
//        margin: EdgeInsets.only(bottom: 10),
        height: 1,
      );
    }

    changeStatusColor(sdAppBackground);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text('Settings', style: boldTextStyle(size: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            // mOption(Icons.language, "Preferences" ,Preferences ),
            // mDivider(),
            // mOption(Icons.lock_outline, "Privacy and Security", PrivacyandSecurity),
            // mDivider(),
            // mOption(Icons.notifications_none, "Notification Settings", NotificationSettings),
            mDivider(),
            mOption(Icons.help_outline, "Đổi mật khẩu", HelpCenter),
            mDivider(),
            mOption(Icons.launch, "Đăng xuất",Logout),
          ],
        ),
      ),
    );
  }
}
