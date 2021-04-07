import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Extension.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

import 'screen/employee/EmployeeModel.dart';

class T1Profile extends StatelessWidget {
  static var tag = "/T1Profile";

  @override
  Widget build(BuildContext context) {
    return FetchDataProfile();
  }
}

class FetchDataProfile extends StatefulWidget {
  @override
  _FetchDataProfileState createState() => _FetchDataProfileState();
}

class _FetchDataProfileState extends State<FetchDataProfile> {
  Future<Profile> profileDetail;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  Future<Profile> fetchData() async {
    User user = await db.getUser();
    String nameid = await api.getNameId(user.sid, "/api/resource/Employee/");
    String profile =
        await api.getData(user.sid, "/api/resource/Employee/" + nameid);
    return Profile.fromJson(jsonDecode(profile)["data"]);
  }

  @override
  Future<void> initState() {
    super.initState();
    profileDetail = fetchData();
  }

  Widget counter(String counter, String counterName) {
    return Column(
      children: <Widget>[

        profile(counter),
        text(counterName,
            textColor: t1TextColorPrimary,
            fontSize: textSizeMedium,
            fontFamily: fontMedium)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(t1_app_background);
    final profileImg = new Container(
      margin: new EdgeInsets.symmetric(horizontal: 16.0),
      alignment: FractionalOffset.center,
      child: new CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(t1_ic_user1),
        radius: 50,
      ),
    );
    final profileContent = new Container(
      margin: new EdgeInsets.only(top: 55.0),
      decoration: boxDecoration(radius: 10, showShadow: true),
      child:          Container(
        margin: EdgeInsets.only(top: 0, left: 16),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Profile>(
                future: profileDetail,
                builder: (context, profiles) {
                  if (profiles.hasData) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 50),
                        text(profiles.data.employee_name,
                            textColor: t1TextColorPrimary,
                            fontSize: textSizeNormal,
                            fontFamily: fontMedium),
                        text(profiles.data.user_id,
                            textColor: t1_colorPrimary,
                            fontSize: textSizeMedium,
                            fontFamily: fontMedium),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: view(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            counter("100", "Task"),
                            counter("50", "Photos"),
                            counter("60", "Videos"),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  } else if (profiles.hasError) {
                    return Text("${profiles.error}");
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: t1_app_background,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 90, left: 2, right: 2),
            physics: ScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Stack(
                      children: <Widget>[profileContent, profileImg],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading(t1_lbl_information),
                                SizedBox(height: 16),
                                profileText(profiles.data.employee_name),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Gender: ",profiles.data.gender),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Birth day: ",profiles.data.date_of_birth),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Date Joining: ",profiles.data.date_of_joining),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Employment Type: ",profiles.data.employment_type),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Address: ",profiles.data.place_of_issue),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                Column(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Html(
                                      data: profiles.data.bio,
                                      style: {
                                        'div': Style(
                                          fontSize: FontSize(textSizeLargeMedium),
                                          color: t1TextColorPrimary,

                                        )
                                      },
                                    ),
                                  )
                                ]),
                                SizedBox(height: 16),
                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading("JOINING DETAILS"),
                                SizedBox(height: 16),
                                profileText(profiles.data.job_applicant),
                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading("DEPARTMENT AND GRADE"),
                                SizedBox(height: 16),
                                profileTextHr("Department: ",profiles.data.department),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Designation: ",profiles.data.designation),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Branch: ",profiles.data.branch),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Reports to: ",profiles.data.reports_to),
                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading("APPROVERS"),
                                SizedBox(height: 16),
                                profileTextHr("Expense: ",profiles.data.expense_approver),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Leave: ",profiles.data.leave_approver),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Shift: ",profiles.data.shift_request_approver),
                                SizedBox(height: 8),

                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading("ATTENDANCE AND LEAVE DETAILS"),
                                SizedBox(height: 16),
                                profileTextHr("ID: ",profiles.data.attendance_device_id),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Default Shift: ",profiles.data.default_shift),
                                SizedBox(height: 8),

                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading("SALARY DETAILS"),
                                SizedBox(height: 16),
                                profileTextHr("Salary mode: ",profiles.data.salary_mode),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 16),
                                profileTextHr("Payroll: ",profiles.data.payroll_cost_center),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Bank name: ",profiles.data.bank_name),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Bank ac: ",profiles.data.bank_ac_no),
                                SizedBox(height: 8),

                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading("HEALTH INSURANCE"),
                                SizedBox(height: 16),
                                profileTextHr("Provider: ",profiles.data.health_insurance_provider),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 16),
                                profileTextHr("No: ",profiles.data.health_insurance_no),
                                SizedBox(height: 8),
                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Profile>(
                        future: profileDetail,
                        builder: (context, profiles) {
                          if (profiles.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 8),
                                rowHeading(t1_lbl_contacts),
                                SizedBox(height: 16),
                                profileTextHr("Phone: ",profiles.data.cell_number),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: view(),
                                ),
                                SizedBox(height: 8),
                                profileTextHr("Email: ",profiles.data.prefered_email),
                                SizedBox(height: 8),
                              ],
                            );
                          } else if (profiles.hasError) {
                            return Text("${profiles.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
