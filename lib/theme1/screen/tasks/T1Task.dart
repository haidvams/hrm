import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/percent_indicator/circular_percent_indicator.dart';
import 'package:hrm/smartDeck/ModelClass/LessonsModelClass.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDLessonsChapterDetailsScreen.dart';
import 'package:hrm/theme1/screen/projects/T1ProjectDetail.dart';
import 'package:hrm/theme1/screen/T1TaskDetail.dart';
import 'package:hrm/theme1/screen/tasks/PostTask.dart';
import 'package:hrm/theme1/screen/tasks/TaskModel.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class T1Task extends StatefulWidget {
  @override
  _SDExamCompletionBoardScreenState createState() =>
      _SDExamCompletionBoardScreenState();
}

class _SDExamCompletionBoardScreenState extends State<T1Task>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;
  String status = "Open";
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  List<TaskModel> tasks = [];

  getProjectDetail() async {
    User user = await db.getUser();
    Iterable gettasks = await api.getDataPublic(
        '/api/resource/Task?fields=["*"]&limit_page_length=0&filters=[["Task","status","=","' +
            status +
            '"],["Task","assign_by","=","' +
            user.username +
            '"]]');
    setState(() {
      tasks =
          gettasks.map((item) => TaskModel.fromJson(item)).toList();
    });
  }

  @override
  initState() {
    super.initState();
    getProjectDetail();
    tabs = ['Open', 'Working', 'Completed'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  Future<void> _handleTabControllerTick() async {
    setState(() {
      if (_tabController.index == 0) {
        status = "Open";
      } else if (_tabController.index == 1) {
        status = "Working";
      } else if (_tabController.index == 2) {
        status = "Completed";
      }
      getProjectDetail();
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                              'My Tasks',
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
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostTask()));
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 35, left: 15, right: 15),
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          (tasks.isEmpty)
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "You don't have any task",
                                    style: secondaryTextStyle(),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Select Your Tasks',
                                    style: secondaryTextStyle(),
                                  ),
                                ),
                          ListView.builder(
                            itemCount: tasks.isEmpty ? 0 : tasks.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => T1TaskDetail(
                                          name: tasks[index].name,
                                          subject: tasks[index].subject,
                                          owner: tasks[index].owner,
                                          status: tasks[index].status,
                                          project: tasks[index].project,
                                          priority: tasks[index].priority,
                                          task_weight: tasks[index]
                                              .task_weight
                                              .toString(),
                                          project_bucket:
                                              tasks[index].project_bucket,
                                          score_volum: tasks[index].score_volum,
                                          score_process:
                                              tasks[index].score_process,
                                          score_range: tasks[index].score_range,
                                          score_complexity:
                                              tasks[index].score_complexity,
                                          score_quality:
                                              tasks[index].score_quality,
                                          range: tasks[index].score_quality,
                                        ),
                                      ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            tasks[index].subject,
                                            style: boldTextStyle(size: 16),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 8, bottom: 5),
                                            child: Text(
                                              "Assign by: " +
                                                  tasks[index].owner,
                                              style:
                                                  secondaryTextStyle(size: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: tasks[index].color)),
                                        color: Colors.white,
                                        textColor: tasks[index].color,
                                        padding: EdgeInsets.all(8.0),
                                        onPressed: () {},
                                        child: Text(
                                          tasks[index].status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: sdSecondaryColorGreen
                                            .withOpacity(0.7),
                                        child: Text(
                                          tasks[index].progress,
                                          style: boldTextStyle(
                                              textColor: CupertinoColors.white,
                                              size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
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

