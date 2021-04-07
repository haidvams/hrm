import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/DeveloperModeScreen.dart';
import 'package:hrm/theme1/screen/employee/T1ProfileEmployee.dart';


class ListShiftManagement extends StatefulWidget {
  @override
  _SDSettingScreenState createState() => _SDSettingScreenState();
}

class _SDSettingScreenState extends State<ListShiftManagement> {
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
          title: Text('Shift Management', style: boldTextStyle(size: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            mOption(Icons.calendar_today, "Shift Type", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.transfer_within_a_station, "Shift Request", DeveloperModeScreen()),
            mDivider(),
            mOption(Icons.assignment, "Shift Assignment", DeveloperModeScreen()),
            mDivider(),
          ],
        ),
      ),
    );
  }
}

