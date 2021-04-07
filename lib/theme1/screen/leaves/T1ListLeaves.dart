import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/DeveloperModeScreen.dart';
import 'package:hrm/theme1/screen/employee/T1ProfileEmployee.dart';

import 'T1EmployeeLeave.dart';

class T1ListLeaves extends StatefulWidget {
  @override
  _SDSettingScreenState createState() => _SDSettingScreenState();
}

class _SDSettingScreenState extends State<T1ListLeaves> {
  @override
  Widget build(BuildContext context) {
    Widget mOption(var icon, var heading, final widgetCate) {
      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widgetCate,
            ),
          );
        },
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
          title: Text('Leaves', style: boldTextStyle(size: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            mOption(Icons.calendar_today, "Leave Application", T1EmployeeLeave()),
            mDivider(),
            mOption(Icons.linear_scale, "Leave Type", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.polymer, "Compensatory Leave Request", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.table_view, "Leave Encashment", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.approval, "Approved Leave", DeveloperModeScreen()),
            mDivider(),
          ],
        ),
      ),
    );
  }
}

