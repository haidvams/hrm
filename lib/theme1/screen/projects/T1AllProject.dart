import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDSettingScreen.dart';
import 'package:hrm/smartDeck/Screens/SDSortScreen.dart';

class T1AllProject extends StatefulWidget {
  @override
  _SDLessonsState createState() => _SDLessonsState();
}

class _SDLessonsState extends State<T1AllProject> {
  List<ModelNavProject> subject = [
    ModelNavProject(
      image: 'images/theme1/icons8-project-48.png',
      subjectName: 'Projects',
      disc: 'all projects',
      url: "/T1Project",
      
    ),
    ModelNavProject(
        image: 'images/theme1/icons8-to_do.png',
        subjectName: 'Task',
        url: "/T1Task",
        disc: 'list task',
       ),
    ModelNavProject(
      image: 'images/theme1/icons8-sand_timer.png',
      subjectName: 'Time Tracking',
      url: "/ListTimeTracking",
      disc: 'Your timesheet',
    ),

  ];

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
                          'Projects',
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
                          'List modun project',
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
                              Navigator.pushNamed(context,subject[index].url);
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
                            title: Text(subject[index].subjectName),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(subject[index].disc),
                            ),
                            trailing: Container(
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
                                  Icons.more_vert,
                                  color: Colors.blue,
                                ),
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

class ModelNavProject {
  String image;
  String url;
  String subjectName;
  String disc;

  ModelNavProject({
    this.image,
    this.url,
    this.subjectName,
    this.disc,
  });
}

