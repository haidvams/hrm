import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';

import 'package:lipsum/lipsum.dart' as lipsum;

class T1TaskDetail extends StatefulWidget {
  String name;
  String owner;
  String subject;
  String project;
  String status;
  String priority;
  String task_weight;
  String project_bucket;
  int score_volum;
  String score_process;
  String score_range;
  String score_complexity;
  String score_quality;
  String range;

  T1TaskDetail({
    this.name,
    this.owner,
    this.subject,
    this.project,
    this.status,
    this.priority,
    this.task_weight,
    this.project_bucket,
    this.score_volum,
    this.score_process,
    this.score_range,
    this.score_complexity,
    this.score_quality,
    this.range,
  });

  @override
  _SDLessonsDetailsScreenState createState() => _SDLessonsDetailsScreenState();
}

class _SDLessonsDetailsScreenState extends State<T1TaskDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: Container(
            child: CloseButton(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.details,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.message,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ],
        ),
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    HeaderWidget("subject: " + widget.subject),
                    HeaderWidget("status: " + widget.status),
                    HeaderWidget("priority: " + widget.priority),
                    HeaderWidget("weight: " + widget.task_weight),
                    HeaderWidget("project_bucket: " + widget.project_bucket),
                    HeaderWidget(
                        "score_volum: " + widget.score_volum.toString()),
                    HeaderWidget("score_process: " + widget.score_process),
                    HeaderWidget("score_range: " + widget.score_range),
                    HeaderWidget(
                        "score_complexity: " + widget.score_complexity),
                    HeaderWidget("score_quality: " + widget.score_quality),
                    HeaderWidget("range: " + widget.range),
                  ],
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            height: 100,
            width: MediaQuery.of(context).copyWith().size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.subject,
                      style: boldTextStyle(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        widget.project,
                        style: secondaryTextStyle(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                      color: sdPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: sdPrimaryColor,
                      size: 30,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(text),
      color: Colors.grey[200],
    );
  }
}
