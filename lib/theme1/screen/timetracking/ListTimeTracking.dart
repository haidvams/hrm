import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/DeveloperModeScreen.dart';
import 'package:hrm/theme1/screen/attendance/BlueCheckin.dart';
import 'package:hrm/theme1/screen/attendance/T1Checkin.dart';
import 'package:hrm/theme1/screen/employee/T1ProfileEmployee.dart';

import '../leaves/T1EmployeeLeave.dart';

class ListTimeTracking extends StatefulWidget {
  @override
  _ListTimeTracking createState() => _ListTimeTracking();
}

class _ListTimeTracking extends State<ListTimeTracking> {
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
          title: Text('Attendance', style: boldTextStyle(size: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            mOption(Icons.timer, "Timesheet", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.merge_type, "Activity Type", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.monetization_on, "Activity Cost", DeveloperModeScreen()),
            mDivider(),
          ],
        ),
      ),
    );
  }
}

