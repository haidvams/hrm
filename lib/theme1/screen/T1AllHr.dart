import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDSettingScreen.dart';
import 'package:hrm/smartDeck/Screens/SDSortScreen.dart';
import 'package:hrm/theme1/screen/T1ListCategories.dart';
import 'package:hrm/theme1/screen/attendance/T1Attendance.dart';
import 'package:hrm/theme1/screen/employee/T1ListEmployee.dart';
import 'package:hrm/theme1/screen/leaves/T1ListLeaves.dart';
import 'package:hrm/theme1/screen/lifecycle/ListLifecycle.dart';
import 'package:hrm/theme1/screen/shiftmanagement/ListShiftManagement.dart';

class T1AllHr extends StatefulWidget {
  @override
  _SDLessonsState createState() => _SDLessonsState();
}

class _SDLessonsState extends State<T1AllHr> {
  var db = new DatabaseHelper();
  String _IDemployee;

  List<CateModunModel> subject = [
    CateModunModel(
      image: 'images/theme1/icons8-collaboration_female_male.png',
      title: 'Employee',
      description: 'My profile',
      cateWidget: T1ListEmployee(),
    ),
    CateModunModel(
      image: 'images/theme1/icons8-life_cycle.png',
      title: 'Employee Lifecycle',
      description: 'Lifecycle',
      cateWidget: T1EmployeeLifecycle(),
    ),
    CateModunModel(
      image: 'images/theme1/icons8-timetable.png',
      title: 'Shift Management',
      description: 'Your timesheet',
      cateWidget: ListShiftManagement(),
    ),
    CateModunModel(
      image: 'images/theme1/icons8-close_program.png',
      title: 'Leaves',
      description: 'Leave Application',
      cateWidget: T1ListLeaves(),
    ),
    CateModunModel(
      image: 'images/theme1/icons8-attendance.png',
      title: 'Attendance',
      description: 'Your timesheet',
      cateWidget: T1Attendance(),
    ),
    // CateModunModel(
    //   image: 'images/theme1/icons8-combo_chart.png',
    //   title: 'Reports',
    //   description: 'Your timesheet',
    //   cateWidget: T1ListCategories(),
    // ),
    // CateModunModel(
    //   image: 'images/theme1/icons8-paycheque.png',
    //   title: 'Expense Claims',
    //   description: 'Your timesheet',
    //   cateWidget: T1ListCategories(),
    // ),
    // CateModunModel(
    //   image: 'images/theme1/icons8-multichannel.png',
    //   title: 'Performance',
    //   description: 'Your timesheet',
    //   cateWidget: T1ListCategories(),
    // ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(sdPrimaryColor);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25),
                color: sdPrimaryColor,
                height: 190,
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Human Resources',
                          style: boldTextStyle(
                            size: 20,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'List modun HR',
                          style: secondaryTextStyle(
                              size: 14, textColor: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 190.0 - 40),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: subject.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 10),
                          width: double.infinity,
                          decoration: boxDecorations(
                            showShadow: true,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => subject[index].cateWidget,
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                subject[index].image,
                                height: 60,
                                width: 60,
                              ),
                            ),
                            title: Text(subject[index].title),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(subject[index].description),
                            ),
                            trailing: Container(
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => SDSortScreen(),
        //         ),
        //       );
        //     },
        //     label: Text(
        //       'Sort By',
        //       style: boldTextStyle(size: 16, textColor: Colors.white),
        //     ),
        //     icon: Icon(Icons.swap_vert)),
      ),
    );
  }
}

class CateModunModel {
  String image;
  String title;
  String description;
  final cateWidget;

  CateModunModel({
    this.image,
    this.title,
    this.description,
    this.cateWidget,
  });
}
