import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';

// import 'package:hrm/smartDeck/ModelClass/SDLessonsDetailsModel.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/T1TaskDetail.dart';

class T1ProjectDetail extends StatefulWidget {
  String id;
  String name;
  String totalTask;
  String backgroundImages;

  T1ProjectDetail({this.id, this.name, this.totalTask, this.backgroundImages});

  @override
  _SDLessonsDetScreenState createState() => _SDLessonsDetScreenState();
}

class _SDLessonsDetScreenState extends State<T1ProjectDetail> {
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  List<progressboardModel> chapters = [];

  getProjectDetail() async {
    User user = await db.getUser();
    widget.totalTask = (await api.getDataPublic(
            '/api/resource/Task?fields=["count( `tabTask`.`name`) AS total_count"]&filters=[["Task","project","=","' +
                widget.id +
                '"]]'))
        .first["total_count"]
        .toString();
    Iterable tasks = await api.getDataPublic(
        '/api/resource/Task?fields=["*"]&limit_page_length=0&filters=[["Task","assign_by","=","' +
            user.username +
            '"],["Task","project","=","' +
            widget.id +
            '"]]');
    setState(() {
      chapters =
          tasks.map((item) => progressboardModel.fromJson(item)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getProjectDetail();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    height: 270,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("images/theme1/Wave-10s-1366px.png"),
                          fit: BoxFit.cover),
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: EdgeInsets.only(top: 22, left: 20),
                          width: size.width,
                          color: Colors.grey.withOpacity(0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black12,
                                child: CloseButton(),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 100),
                                child: Text(
                                  widget.name == null ? 'Biology' : widget.name,
                                  style: boldTextStyle(textColor: Colors.white),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.totalTask == null
                                      ? ''
                                      : widget.totalTask + " Tasks",
                                  style: secondaryTextStyle(
                                      textColor: Colors.white.withOpacity(0.8)),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: AssetImage(
                                                'images/theme1/icons8-user-48.png'),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            top: 25,
                                            child: CircleAvatar(
                                              radius: 5,
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.green,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 0),
                                            child: Text(
                                              'Haidv',
                                              style: boldTextStyle(
                                                  size: 16,
                                                  textColor: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              'Leader',
                                              style: secondaryTextStyle(
                                                  size: 10,
                                                  textColor: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 200,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return FilterDialog();
                            });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: AssetImage(
                                  "images/app/icons/icons8-filter-100.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 35, left: 15, right: 15),
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (chapters.isEmpty)
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
                      itemCount: chapters.isEmpty ? 0 : chapters.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => T1TaskDetail(
                                    name: chapters[index].name,
                                    subject: chapters[index].subject,
                                    owner: chapters[index].owner,
                                    status: chapters[index].status,
                                    project: chapters[index].project,
                                    priority: chapters[index].priority,
                                    task_weight:
                                        chapters[index].task_weight.toString(),
                                    project_bucket:
                                        chapters[index].project_bucket,
                                    score_volum: chapters[index].score_volum,
                                    score_process:
                                        chapters[index].score_process,
                                    score_range: chapters[index].score_range,
                                    score_complexity:
                                        chapters[index].score_complexity,
                                    score_quality:
                                        chapters[index].score_quality,
                                    range: chapters[index].score_quality,
                                  ),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      chapters[index].subject,
                                      style: boldTextStyle(size: 16),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 8, bottom: 5),
                                      child: Text(
                                        "Assign by: " + chapters[index].owner,
                                        style: secondaryTextStyle(size: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: chapters[index].color)),
                                  color: Colors.white,
                                  textColor: chapters[index].color,
                                  padding: EdgeInsets.all(8.0),
                                  onPressed: () {},
                                  child: Text(
                                    chapters[index].status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      sdSecondaryColorGreen.withOpacity(0.7),
                                  child: Text(
                                    chapters[index].progress,
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
    );
  }
}

class FilterDialog extends StatelessWidget {
  const FilterDialog({
    Key key,
  }) : super(key: key);

  static void hide(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AllFieldsFormBloc(),
        child: Builder(builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 16,
              child: FormBlocListener<AllFieldsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  // LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  FilterDialog.hide(context);
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Filter Task",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.reason,
                          decoration: InputDecoration(
                            labelText: 'Name task',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        DropdownFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.type,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            prefixIcon: Icon(Icons.sentiment_satisfied),
                          ),
                          itemBuilder: (context, value) => value,
                        ),
                        DateTimeFieldBlocBuilder(
                          dateTimeFieldBloc: formBloc.fromdate,
                          format: DateFormat('dd-mm-yyyy'),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          decoration: InputDecoration(
                            labelText: 'From Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            helperText: 'Date',
                          ),
                        ),
                        DateTimeFieldBlocBuilder(
                          dateTimeFieldBloc: formBloc.todate,
                          format: DateFormat('dd-mm-yyyy'),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          decoration: InputDecoration(
                            labelText: 'To Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            helperText: 'Date',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        }));
  }
}

class AllFieldsFormBloc extends FormBloc<String, String> {
  final reason = TextFieldBloc();

  final boolean1 = BooleanFieldBloc();

  final halfcheck = BooleanFieldBloc();

  final type = SelectFieldBloc(
    items: ['Open', 'Working', 'Completed'],
  );

  final fromdate = InputFieldBloc<DateTime, Object>();
  final todate = InputFieldBloc<DateTime, Object>();
  final bool _isVisible = false;

  final dateAndTime1 = InputFieldBloc<DateTime, Object>();

  final time1 = InputFieldBloc<TimeOfDay, Object>();

  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      reason,
      boolean1,
      halfcheck,
      type,
      fromdate,
      todate,
      dateAndTime1,
      time1,
    ]);
  }

  addErrors() {
    if (type.value == null) {
      type.addFieldError('Please select!');
      return false;
    }
    if (fromdate.value == null) {
      fromdate.addFieldError('Please select!');
      return false;
    }
    if (todate.value == null) {
      todate.addFieldError('Please select!');
      return false;
    }
    if (fromdate.value.millisecondsSinceEpoch >
        todate.value.millisecondsSinceEpoch) {
      fromdate.addFieldError('Please select less than to date!');
      return false;
    }
    return true;
  }

  @override
  void onSubmitting() async {}
}

class progressboardModel {
  String subject;
  String owner;
  String progress;
  String status;
  String name;
  Color color;
  String project;
  String priority;
  double task_weight;
  String project_bucket;
  int score_volum;
  String score_process;
  String score_range;
  String score_complexity;
  String score_quality;
  String range;

  progressboardModel({
    this.subject,
    this.owner,
    this.progress,
    this.name,
    this.color,
    this.status,
    this.project,
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

  static ChangeStatus(String status) {
    switch (status) {
      case "Pending":
        return "20";
        break;
      case "Overdue":
        return "00";
      case "Open":
        return "1O";
      case "Working":
        return "30";
      case "Completed":
        return "100";
        break;
    }
  }

  static ChangeColors(String status) {
    switch (status) {
      case "Pending":
        return Colors.blue;
        break;
      case "Overdue":
        return Colors.red;
      case "Open":
        return Colors.grey;
      case "Working":
        return Colors.yellow;
      case "Completed":
        return Colors.green;
        break;
    }
  }

  factory progressboardModel.fromJson(Map<String, dynamic> json) {
    return progressboardModel(
      subject: json['subject'],
      owner: json['owner'],
      progress: ChangeStatus(json['status']),
      status: json['status'],
      name: json['name'],
      color: ChangeColors(json['status']),
      project: json['project'] ??= "",
      priority: json['priority'] ??= "",
      task_weight: json['task_weight'] ??= "",
      project_bucket: json['project_bucket'] ??= "",
      score_volum: json['score_volum'] ??= "",
      score_process: json['score_process'] ??= "",
      score_range: json['score_range'] ??= "",
      score_complexity: json['score_complexity'] ??= "",
      score_quality: json['score_quality'] ??= "",
      range: json['range'] ??= "",
    );
  }
}
