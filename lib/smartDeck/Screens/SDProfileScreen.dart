import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hrm/smartDeck/Screens/SDSettingScreen.dart';

import 'SDEditProfileScreen.dart';

class sdPRofileScreen extends StatefulWidget {
  @override
  _sdPRofileScreenState createState() => _sdPRofileScreenState();
}

class _sdPRofileScreenState extends State<sdPRofileScreen> {
  Future<Profile> profileDetail;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  String nameid;

  Future<Profile> fetchData() async {
    User user = await db.getUser();
    nameid = await api.getNameId(user.sid, "/api/resource/Employee/");
    String profile =
        await api.getData(user.sid, "/api/resource/Employee/" + nameid);
    return Profile.fromJson(jsonDecode(profile)["data"]);
  }

  List<charts.Series<Task, String>> _taskPieData;

  _generateData() {
    var taskData = [
      Task(task: 'Completed', value: 82.0, color: Colors.blue),
      Task(task: 'On going', value: 22.0, color: Colors.deepOrangeAccent),
    ];

    _taskPieData.add(
      charts.Series(
        data: taskData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.value,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
        id: 'Montlhy',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _taskPieData = List<charts.Series<Task, String>>();
    _generateData();
    profileDetail = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(sdPrimaryColor);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: 320,
              width: size.width,
              padding: EdgeInsets.only(top: 50, right: 10),
              color: sdPrimaryColor,
              child: FutureBuilder<Profile>(
                future: profileDetail,
                builder: (context, profiles) {
                  if (profiles.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SDSettingScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 80,
                          width: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage(
                                'images/theme1/icons8-more_info_skin_type_7.png',
                              ),
                              image: profiles.data.avatar == null
                                  ? AssetImage(
                                      'images/theme1/icons8-more_info_skin_type_7.png')
                                  : NetworkImage(RestDatasource.BASE_URL +
                                      profiles.data.avatar),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            profiles.data.employee_name,
                            style: boldTextStyle(textColor: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            profiles.data.department,
                            style: secondaryTextStyle(
                              size: 12,
                              textColor: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SDEditProfileScreen(),
                              ),
                            );
                          },
                          child: FittedBox(
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                              decoration: boxDecorations(
                                radius: 4,
                              ),
                              child: Center(
                                child: Text(
                                  'Edit Profile',
                                  style: boldTextStyle(
                                      size: 12, textColor: sdPrimaryColor),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else if (profiles.hasError) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SDSettingScreen(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text("errors"),
                          )
                        ]);
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 320.00 - 50,
                      ),
                      padding: EdgeInsets.all(20),
                      decoration: boxDecoration(
                        radius: 8,
                        backGroundColor: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Highest Score',
                            style: boldTextStyle(
                                textColor: Colors.black, size: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '98',
                            style: boldTextStyle(
                              textColor: Colors.green.withOpacity(0.8),
                              size: 26,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Chemist',
                            style: secondaryTextStyle(
                                textColor: Colors.grey.withOpacity(0.7),
                                size: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 320.00 - 50,
                      ),
                      padding: EdgeInsets.all(20),
                      decoration: boxDecoration(
                          radius: 8,
                          backGroundColor: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lowest Score',
                            style: boldTextStyle(
                                textColor: Colors.black, size: 14),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '67',
                            style: boldTextStyle(
                              textColor:
                                  sdSecondaryColorYellow.withOpacity(0.7),
                              size: 26,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Maths',
                            style: secondaryTextStyle(
                                textColor: Colors.grey.withOpacity(0.7),
                                size: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: 320.00 + 100, bottom: 25, left: 16, right: 16),
                padding: EdgeInsets.only(
                  top: 5,
                  left: 15,
                  right: 15,
                ),
                decoration: boxDecorations(
                  showShadow: true,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Completion Task',
                              style: boldTextStyle(size: 16)),
                        ),
                        Container(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: 'Monthly',
                              items: <String>[
                                'Daily',
                                'Weekly',
                                'Monthly',
                                'Yearly'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    value,
                                    style: boldTextStyle(size: 16),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {},
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: charts.PieChart(
                              _taskPieData,
                              animate: true,
                              animationDuration: Duration(seconds: 1),
                              behaviors: [
                                charts.DatumLegend(
                                  position: charts.BehaviorPosition.end,
                                  outsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
                                  horizontalFirst: false,
                                  showMeasures: true,
                                  cellPadding:
                                      new EdgeInsets.only(right: 4.0, top: 25),
                                  legendDefaultMeasure:
                                      charts.LegendDefaultMeasure.lastValue,
                                  measureFormatter: (num value) {
                                    return value == null ? '-' : '$value%';
                                  },
                                  entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                              defaultRenderer: charts.ArcRendererConfig(
                                arcWidth: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String task;
  double value;
  Color color;

  Task({this.task, this.value, this.color});
}

class Profile {
  final String employee_name;
  final String employee;
  final String employment_type;
  final String company;
  final String date_of_joining;
  final String date_of_birth;
  final String emergency_phone_number;
  final String user_id;
  final String job_applicant;
  final String branch;
  final String department;
  final String designation;
  final String reports_to;
  final String expense_approver;
  final String leave_approver;
  final String shift_request_approver;
  final String salary_mode;
  final String bank_name;
  final String bank_ac_no;
  final String health_insurance_provider;
  final String health_insurance_no;
  final String bio;
  final String passport_number;
  final String date_of_issue;
  final String valid_upto;
  final String place_of_issue;
  final String family_background;
  final String blood_group;
  final String health_details;
  final String gender;
  final List education;
  final List external_work_history;
  final List internal_work_history;
  final String attendance_device_id;
  final String default_shift;
  final String payroll_cost_center;
  final String cell_number;
  final String prefered_email;
  String avatar;

  Profile({
    this.employee_name,
    this.employee,
    this.employment_type,
    this.company,
    this.date_of_joining,
    this.date_of_birth,
    this.emergency_phone_number,
    this.user_id,
    this.job_applicant,
    this.branch,
    this.department,
    this.designation,
    this.reports_to,
    this.expense_approver,
    this.leave_approver,
    this.shift_request_approver,
    this.salary_mode,
    this.bank_name,
    this.bank_ac_no,
    this.health_insurance_provider,
    this.health_insurance_no,
    this.health_details,
    this.blood_group,
    this.bio,
    this.passport_number,
    this.date_of_issue,
    this.valid_upto,
    this.place_of_issue,
    this.family_background,
    this.education,
    this.external_work_history,
    this.internal_work_history,
    this.gender,
    this.attendance_device_id,
    this.default_shift,
    this.payroll_cost_center,
    this.cell_number,
    this.prefered_email,
    this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      employee: json['employee'] ??= null,
      employee_name: json['employee_name'] ??= null,
      employment_type: json['employment_type'] ??= null,
      company: json['company'] ??= null,
      date_of_joining: json['date_of_joining'] ??= null,
      date_of_birth: json['date_of_birth'] ??= null,
      emergency_phone_number: json['emergency_phone_number'] ??= null,
      user_id: json['user_id'] ??= null,
      job_applicant: json['job_applicant'] ??= null,
      branch: json['branch'] ??= null,
      department: json['department'] ??= null,
      designation: json['designation'] ??= null,
      reports_to: json['reports_to'] ??= null,
      expense_approver: json['expense_approver'] ??= null,
      leave_approver: json['leave_approver'] ??= null,
      shift_request_approver: json['shift_request_approver'] ??= null,
      salary_mode: json['salary_mode'] ??= null,
      bank_name: json['bank_name'] ??= null,
      bank_ac_no: json['bank_ac_no'] ??= null,
      health_insurance_provider: json['health_insurance_provider'] ??= null,
      health_insurance_no: json['health_insurance_no'] ??= null,
      health_details: json['health_details'] ??= null,
      blood_group: json['blood_group'] ??= null,
      bio: json['bio'] ??= null,
      passport_number: json['passport_number'] ??= null,
      date_of_issue: json['date_of_issue'] ??= null,
      valid_upto: json['valid_upto'] ??= null,
      place_of_issue: json['place_of_issue'] ??= null,
      family_background: json['family_background'] ??= null,
      education: json['education'] ??= null,
      external_work_history: json['external_work_history'] ??= null,
      internal_work_history: json['internal_work_history'] ??= null,
      gender: json['gender'] ??= null,
      attendance_device_id: json['attendance_device_id'] ??= null,
      default_shift: json['default_shift'] ??= null,
      payroll_cost_center: json['payroll_cost_center'] ??= null,
      cell_number: json['cell_number'] ??= null,
      prefered_email: json['prefered_email'] ??= null,
      avatar: json['avatar'] ??= null,
    );
  }
}
