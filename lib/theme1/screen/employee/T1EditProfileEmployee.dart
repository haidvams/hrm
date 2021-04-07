import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';

// import 'package:hrm/integrations/screens/ShowViewCase/SVCHomePage.dart';
import 'package:hrm/main/utils/SDStyle.dart';

class T1EditProfileEmployee extends StatefulWidget {
  String name;

  T1EditProfileEmployee(this.name);

  @override
  _SDEditProfileScreenState createState() => _SDEditProfileScreenState();
}

class _SDEditProfileScreenState extends State<T1EditProfileEmployee> {
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

  @override
  Future<void> initState() {
    super.initState();
    profileDetail = fetchData();
  }

  @override
  Widget build(BuildContext context) {

    Widget mInput(var mLabel) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 10, 16),
        child: TextField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              hintText: mLabel,
              border: InputBorder.none),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Text('Edit Profile', style: boldTextStyle(size: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<Profile>(
            future: profileDetail,
            builder: (context, profiles) {
              if (profiles.hasData) {
                return Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      CircleAvatar(
                          radius: 45,
                          backgroundImage: profiles.data.avarta == null
                              ? AssetImage('images/theme1/icons8-more_info_skin_type_7.png')
                              : NetworkImage(RestDatasource.BASE_URL + profiles.data.avarta)),
                      FittedBox(
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                          decoration:
                              boxDecorations(radius: 4, bgColor: Colors.green),
                          child: Center(
                            child: Text('Change Profile Photo',
                                style: boldTextStyle(
                                    size: 12, textColor: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: boxDecorations(showShadow: true),
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            mInput(profiles.data.employee_name),
                            Divider(height: 1, thickness: 1),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: profiles.data.gender == null ? "Prefer not to say" : profiles.data.gender,
                                items: <String>['Female', 'Male', 'Prefer not to say']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: primaryTextStyle(
                                            size: 16, textColor: Colors.green)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    var _selectedLocation = newValue;
                                  });
                                },
                              ),
                            ),
                            Divider(height: 1, thickness: 1),
                            mInput(profiles.data.prefered_email),
                            Divider(height: 1, thickness: 1),
                            mInput("Ha Noi"),
                            Divider(height: 1, thickness: 1),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: '166 Tran vi',
                                items: <String>[
                                  '166 Tran vi',
                                  // 'B.Tech',
                                  // '10th Grade'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: primaryTextStyle(
                                            size: 16, textColor: Colors.green)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    var _selectedValue = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ]);
              } else if (profiles.hasError) {
                return Text("${profiles.error}");
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator(),);
            },
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).copyWith().size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: secondaryTextStyle()),
                ),
                FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      decoration:
                          boxDecorations(radius: 4, bgColor: Colors.green),
                      child: Center(
                        child: Text('Save',
                            style: boldTextStyle(
                                size: 12, textColor: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
  String avarta;

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
    this.avarta,
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
      avarta: json['avarta'] ??= null,

    );
  }
}
