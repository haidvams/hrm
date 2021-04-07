import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/attendance/T1PostChekin.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class T1Checkin extends StatefulWidget {
  @override
  _SDExamCompletionBoardScreenState createState() =>
      _SDExamCompletionBoardScreenState();
}

class _SDExamCompletionBoardScreenState extends State<T1Checkin>
    with SingleTickerProviderStateMixin {
  List<ModelCheckin> listData = [];

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  bool _progresStatus = true;

  @override
  initState() {
    super.initState();
    _handleTabControllerTick();
  }

  void _handleTabControllerTick() async {
    User user = await db.getUser();
    Iterable data = await api.getDataPrivate(
        '/api/resource/Employee Checkin?fields=["*"]&order_by=`tabEmployee Checkin`.`modified` desc',
        user.sid);
    setState(() {
      listData = data.map((model) => ModelCheckin.fromJson(model)).toList();
      _progresStatus = false;
    });
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
                            Icons.close,
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
                              'Danh sách Checkin',
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: fontBold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.add,
                        //       color: Colors.white,
                        //     ),
                        //     onPressed: () {
                        //       Navigator.push(context,MaterialPageRoute(
                        //           builder: (context) => T1PostChekin(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _progresStatus,
              child: CircularProgressIndicator(),
            ),
            if (listData.length > 0)
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(bottom: 16),
                    itemCount: listData.length,
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
                                  ? [
                                      BoxShadow(
                                          color: shadow_color,
                                          blurRadius: 2,
                                          spreadRadius: 2)
                                    ]
                                  : [BoxShadow(color: Colors.transparent)],
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 8),
                                  rowHeading(listData[index].name),
                                  SizedBox(height: 16),
                                  profileTextHr(
                                      "Status: ", listData[index].log_type),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 10, 16, 10),
                                    child: view(),
                                  ),
                                  SizedBox(height: 5),
                                  profileTextHr("Time: ",
                                      listData[index].time.toString()),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 10, 16, 10),
                                    child: view(),
                                  ),
                                  SizedBox(height: 5),
                                  profileTextHr(
                                      "shift: ", listData[index].shift),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 10, 16, 10),
                                    child: view(),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    child: Text("Device ID: "+ listData[index].device_id,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: secondaryTextStyle(size: 12)
                                    ),
                                  ),

                                  SizedBox(height: 5),
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
                child: Text("No Data",
                    style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
          ],
        ),
      ),
    );
  }
}

class ModelCheckin {
  String name;
  String employee_name;
  String employee;
  String log_type;
  String time;
  int skip_auto_attendance;
  String shift;
  String device_id;

  ModelCheckin({
    this.name,
    this.employee_name,
    this.employee,
    this.log_type,
    this.time,
    this.skip_auto_attendance,
    this.shift,
    this.device_id,
  });

  factory ModelCheckin.fromJson(Map<String, dynamic> json) {
    return ModelCheckin(
      name: json['name'],
      employee_name: json['employee_name'],
      employee: json['employee'],
      log_type: json['log_type'],
      time: json['time'],
      skip_auto_attendance: json['skip_auto_attendance'],
      device_id: json['device_id'] ??= "Empty",
      shift: json['shift'] ??= "",
    );
  }
}
