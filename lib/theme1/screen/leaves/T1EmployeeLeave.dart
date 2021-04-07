import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class T1EmployeeLeave extends StatefulWidget {
  @override
  _SDExamCompletionBoardScreenState createState() =>
      _SDExamCompletionBoardScreenState();
}

class _SDExamCompletionBoardScreenState extends State<T1EmployeeLeave>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  List<ModelLeave> scoreboardAvailable = [];

  List<ModelLeave> scoreboardPassed = [];

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  @override initState() {
    super.initState();

    tabs = ['Approved', 'History'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() async {
    User user = await db.getUser();
    Iterable data = await api.getDataPrivate(
        '/api/resource/Leave Application?fields=["*"]', user.sid);
    setState(() {
      _currentIndex = _tabController.index;
      if (_tabController.index == 1) {
        scoreboardPassed =
            data.map((model) => ModelLeave.fromJson(model)).toList();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget counter(String counter, String counterName) {
    return Column(
      children: <Widget>[
        profile(counter),
        text(counterName,
            textColor: t1TextColorPrimary,
            fontSize: textSizeMedium,
            fontFamily: fontMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    changeStatusColor(sdPrimaryColor);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              color: sdPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 16),
                    child: Stack(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Center(
                            child: Text(
                              'Leave',
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: fontBold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/T1LeaveApplication");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 4.0,
                    labelColor: Colors.white,
                    labelStyle: boldTextStyle(size: 14),
                    unselectedLabelColor: Colors.white.withOpacity(.5),
                    controller: _tabController,
                    tabs: tabs.map((e) => Tab(text: e)).toList(),
                  ),
                ],
              ),
            ),
            if (_currentIndex == 0)
              if (scoreboardAvailable.length > 0)
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: scoreboardAvailable.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          width: double.infinity,
                          decoration: boxDecorations(
                            showShadow: true,
                          ),
                          child: Text(scoreboardAvailable[index].employee_name),
                        );
                      }),
                )
              else
                Center(
                  heightFactor: 20,
                  child: Text("No data",
                      style: TextStyle(color: Colors.black, fontSize: 20.0)),
                )
            else if (_currentIndex == 1)
              if (scoreboardPassed.length > 0)
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: scoreboardPassed.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(height: 8),
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              decoration: BoxDecoration(
                                color: t1_white,
                                boxShadow: true
                                    ? [BoxShadow(color: shadow_color, blurRadius: 2, spreadRadius: 2)]
                                    : [BoxShadow(color: Colors.transparent)],
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 8),
                                    rowHeading(scoreboardPassed[index].leave_type + " (" + scoreboardPassed[index].total_leave_days.toString() + " Day)" ),
                                    SizedBox(height: 16),
                                    profileTextHr("Status: ",scoreboardPassed[index].status),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                      child: view(),
                                    ),
                                    SizedBox(height: 16),
                                    profileTextHr("From: ",scoreboardPassed[index].from_date),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                      child: view(),
                                    ),
                                    SizedBox(height: 8),
                                    profileTextHr("To: ",scoreboardPassed[index].to_date),

                                    SizedBox(height: 8),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                )
              else
                Center(
                  heightFactor: 20,
                  child: Text("No data",
                      style: TextStyle(color: Colors.black, fontSize: 20.0)),
                )
          ],
        ),
      ),
    );
  }
}

class ModelLeave {
  String name;
  String employee_name;
  String leave_type;
  double leave_balance;
  String from_date;
  String to_date;
  int half_day;
  String half_day_date;
  double total_leave_days;
  String description;
  String leave_approver;
  String leave_approver_name;
  String status;
  String posting_date;
  int follow_via_email;
  String color;

  ModelLeave({
    this.name,
    this.employee_name,
    this.leave_type,
    this.leave_balance,
    this.from_date,
    this.to_date,
    this.half_day,
    this.half_day_date,
    this.total_leave_days,
    this.description,
    this.leave_approver,
    this.leave_approver_name,
    this.status,
    this.posting_date,
    this.follow_via_email,
    this.color,
  });

  factory ModelLeave.fromJson(Map<String, dynamic> json) {
    return ModelLeave(
      name: json['name'],
      employee_name: json['employee_name'],
      leave_type: json['leave_type'],
      leave_balance: json['leave_balance'],
      from_date: json['from_date'],
      to_date: json['to_date'],
      half_day: json['half_day'],
      half_day_date: json['half_day_date'],
      total_leave_days: json['total_leave_days'],
      description: json['description'],
      leave_approver: json['leave_approver'],
      leave_approver_name: json['leave_approver_name'],
      status: json['status'],
      posting_date: json['posting_date'],
      follow_via_email: json['follow_via_email'],
      color: json['color'],
    );
  }
}
