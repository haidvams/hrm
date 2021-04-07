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
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class T1Project extends StatefulWidget {
  @override
  _SDExamCompletionBoardScreenState createState() =>
      _SDExamCompletionBoardScreenState();
}

class _SDExamCompletionBoardScreenState extends State<T1Project>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  List<ScoreboardModel> scoreboardAvailable = [];

  List<ScoreboardModel> scoreboardPassed = [];

  getProject() async {
    Iterable data =
        await api.getDataPublic('/api/resource/Project?fields=["*"]');
    setState(() {
      scoreboardAvailable =
          data.map((item) => ScoreboardModel.fromJson(item)).toList();
    });
  }

  @override
  initState() {
    super.initState();
    getProject();
    tabs = ['Process', 'Passed'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
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


    AlertDialogPermiss(BuildContext context) {
      // set up the buttons

      Widget cancelButton = FlatButton(
        child: Text("Close"),
        onPressed:  () {
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text("You do not have permission \nto create a new project!"),
        actions: [
          cancelButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


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
                              'Projects',
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
                              AlertDialogPermiss(context);
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
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => T1ProjectDetail(
                                    id: scoreboardAvailable[index].name,
                                    name: scoreboardAvailable[index].title,
                                    backgroundImages: scoreboardAvailable[index]
                                        .backgroundImages),
                              ),
                            );
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: AssetImage(
                                  'images/theme1/icons8-loading-sign-100.png',
                                ),
                                image: Image.asset(
                                  scoreboardAvailable[index].image,
                                  height: 35,
                                  width: 20,
                                ).image,
                              ),
                            ),
                          ),
                          title: Text(
                            scoreboardAvailable[index].title,
                            style: boldTextStyle(size: 16),
                          ),
                          subtitle: Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "Status: " + scoreboardAvailable[index].subtitle,
                              style: secondaryTextStyle(size: 10),
                            ),
                          ),
                          trailing: CircularPercentIndicator(
                            radius: 30.0,
                            lineWidth: 3.0,
                            animation: true,
                            percent:
                                scoreboardAvailable[index].status.toDouble(),
                            backgroundColor: sdViewColor,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: sdPrimaryColor,
                          ),
                        ),
                      );
                    }),
              )
            else if (_currentIndex == 1)
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(bottom: 16),
                    // itemCount: scoreboardPassed.length,
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10,10,10,10),
                        child: Text(
                          "You don't have any task",
                          style: secondaryTextStyle(),
                        ),
                      );
                      return Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        width: double.infinity,
                        decoration: boxDecorations(
                          showShadow: true,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SDLessonsDetScreen(
                                  name: scoreboardPassed[index].title,
                                  backgroundImages:
                                      scoreboardPassed[index].backgroundImages,
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: AssetImage(
                                  'Loading',
                                ),
                                image: Image.asset(
                                  scoreboardPassed[index].image,
                                  height: 35,
                                  width: 20,
                                ).image,
                              ),
                            ),
                          ),
                          title: Text(
                            scoreboardPassed[index].title,
                            style: boldTextStyle(size: 16),
                          ),
                          subtitle: Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              "Status: " + scoreboardPassed[index].subtitle,
                              style: secondaryTextStyle(size: 10),
                            ),
                          ),
                          trailing: CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                (scoreboardPassed[index].status > 70)
                                    ? sdSecondaryColorGreen.withOpacity(0.7)
                                    : sdSecondaryColorYellow.withOpacity(0.7),
                            child: Text(
                              scoreboardPassed[index].status.toInt().toString(),
                              style: boldTextStyle(
                                  textColor: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      );
                    }),
              )
          ],
        ),
      ),
    );
  }
}

class ScoreboardModel {
  String name;
  String image;
  String title;
  String subtitle;
  double status;
  String backgroundImages;

  ScoreboardModel({
    this.name,
    this.image,
    this.title,
    this.subtitle,
    this.status,
    this.backgroundImages,
  });

  factory ScoreboardModel.fromJson(Map<String, dynamic> json) {
    return ScoreboardModel(
      name: json['name'],
      image: 'images/theme1/icons8-project-48.png',
      title: json['project_name'] ??= "No name",
      subtitle: json['status'] ??= "",
      status: json['percent_complete'].toDouble() / 100 ?? 1,
      backgroundImages:
          "images/theme1/Wave-10s-1366px.png",
    );
  }
}
