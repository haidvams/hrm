import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/tasks/PostTask.dart';
import 'package:hrm/theme1/screen/tasks/TaskModel.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';

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
  List users = [];

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

  static ChangeColors(String Complexity) {
    switch (Complexity) {
      case "Low":
        return Colors.green;
        break;
      case "Medium":
        return Colors.yellow;
      case "High":
        return Colors.red;
    }
  }

  @override
  initState() {
    super.initState();
    getProjectDetail();
    tabs = ['Open', 'Working', 'Completed','Overdue'];
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
      } else if (_tabController.index == 3) {
        status = "Overdue";
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
                              'Việc của tôi',
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
                              return Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 10),
                                  width: double.infinity,
                                  decoration: boxDecorations(
                                    showShadow: true,
                                  ),
                                  child: ExpansionTile(
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          tasks[index].subject,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "Deadline:" + tasks[index].exp_end_date,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    leading: Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                            ChangeColors(tasks[index].complexity),
                                            //                   <--- border color
                                            width: 1.0),
                                      ),
                                      //       <--- BoxDecoration here
                                      child: Center(
                                        child: Text(
                                          tasks[index].complexity.substring(0, 1),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: ChangeColors(
                                                  tasks[index].complexity)),
                                        ),
                                      ),
                                    ),
                                    // trailing: RaisedButton(
                                    //   child: Text(tasks[index].task_weight == 0
                                    //       ? 'CONFIRM'
                                    //       : "CONFIRMED"),
                                    //   color: Color(tasks[index].task_weight == 0
                                    //       ? 0xFF0A79DF
                                    //       : 0xFF8c8c8c),
                                    //   textColor: Colors.white,
                                    //   onPressed: () {
                                    //    print("da click");
                                    //   },
                                    // ),
                                    children: <Widget>[
                                      _buildAdvRow(context, 'Report to',
                                          tasks[index].report_to ?? "N/A"),
                                      _buildAdvRow(context, 'Thời lượng(H)',
                                          tasks[index].task_weight.toString() ?? "N/A"),
                                      _buildAdvRow(context, 'Phạm vi',
                                          tasks[index].range == 1 ? "Trong" : "Ngoài"),
                                      // _buildAdvRow(
                                      //     context,
                                      //     'Project',
                                      //     tasks[index].project == ""
                                      //         ? "N/A"
                                      //         : tasks[index].project),
                                      _buildAdvRow(
                                          context,
                                          'Dự án',
                                          tasks[index].project_bucket == ""
                                              ? "N/A"
                                              : tasks[index].project_bucket),
                                      _buildAdvRow(
                                          context,
                                          'Trạng thái',
                                          tasks[index].status == ""
                                              ? "N/A"
                                              : tasks[index].status),
                                    ],
                                  ));

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


  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

}

