import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDSettingScreen.dart';
import 'package:hrm/smartDeck/Screens/SDSortScreen.dart';
import 'package:hrm/theme1/screen/tasks/PopupFormConfirm.dart';
import 'package:hrm/theme1/screen/tasks/TaskModel.dart';

class ComfirmTask extends StatefulWidget {
  ComfirmTask({Key key}) : super(key: key);

  @override
  _ComfirmTask createState() => _ComfirmTask();
}

class _ComfirmTask extends State<ComfirmTask> {
  String status = "Open";
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<TaskModel> tasks = [];

  getListTasks() async {
    User user = await db.getUser();
    Iterable gettasks = await api.getDataPublic(
        '/api/resource/Task?fields=["*"]&limit_page_length=0&filters=[["Task","assign_by","=","' +
            user.username +
            '"],["Task","confirmation_status","=","Pending"],["Task","status","=","Open"]]');
    setState(() {
      tasks = gettasks.map((item) => TaskModel.fromJson(item)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListTasks();
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

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body:  Column(
          children: [
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
                              'Task Comfirm',
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: "bold",
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
                              print("click");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () => getListTasks(),
                  child: Stack(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.only(bottom: 16),
                          itemCount: tasks.isEmpty ? 0 : tasks.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
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
                                  trailing: RaisedButton(
                                    child: Text(tasks[index].task_weight == 0
                                        ? 'CONFIRM'
                                        : "CONFIRMED"),
                                    color: Color(tasks[index].task_weight == 0
                                        ? 0xFF0A79DF
                                        : 0xFF8c8c8c),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      tasks[index].task_weight == 0
                                          ? _ShowFormConFirm(
                                          context, tasks[index].name)
                                          : null;
                                    },
                                  ),
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
                          }),
                      if (tasks.isEmpty)
                        Center(
                          child: Text("No Data"),
                        ),
                    ],
                  ),
                ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _ShowFormConFirm(BuildContext context, String nameID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => _PopupFormBloc(nameID),
                  child: Builder(
                    builder: (context) {
                      final formBloc = BlocProvider.of<_PopupFormBloc>(context);
                      return Stack(
                        overflow: Overflow.visible,
                        children: [
                          FormBlocListener<_PopupFormBloc, String, String>(
                            onSubmitting: (context, state) {

                            },
                            onSuccess: (context, state) {
                              Navigator.pop(context);
                              setState(() {});
                            },
                            onFailure: (context, state) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(state.failureResponse)));
                            },
                            child: Column(
                              children: <Widget>[
                                TextFieldBlocBuilder(
                                  keyboardType: TextInputType.number,
                                  textFieldBloc: formBloc.task_weight,
                                  decoration: InputDecoration(
                                    labelText: 'Thời lượng (H)',
                                    prefixIcon: Icon(Icons.text_fields),
                                  ),
                                ),
                                SwitchFieldBlocBuilder(
                                  booleanFieldBloc: formBloc.range,
                                  body: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Trong phạm vi ?'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    var check = await formBloc.addErrors();
                                    if (check) {
                                       await formBloc.submit();
                                       await getListTasks();
                                      _showSnackBar("Update success");
                                    }
                                  },
                                  child: Text('Submit'),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
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

class _PopupFormBloc extends FormBloc<String, String> {
  final task_weight = TextFieldBloc();

  String nameID;

  final range = BooleanFieldBloc();

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  _PopupFormBloc(this.nameID) {
    addFieldBlocs(fieldBlocs: [
      task_weight,
      range,
    ]);
  }

  addErrors() {
    if (task_weight.value.isEmpty) {
      task_weight.addFieldError('Please enter!');
      return false;
    }
    return true;
  }

  Future postLeaveDraft(var dataBody) async {
    User user = await db.getUser();
    return api.postleaveDraft(
        '/api/resource/Leave Application', user.sid, dataBody);
  }

  @override
  void onSubmitting() async {
    Map dataBody = await {
      "range": range.value ? 1 : 0,
      "task_weight": task_weight.value,
    };

    try {
      var res =
          await api.updatePublicDetail('/api/resource/Task/$nameID', dataBody);
      if (res == true) {
        await Future<void>.delayed(Duration(milliseconds: 500));
        emitSuccess(canSubmitAgain: true);
      } else {
        await Future<void>.delayed(Duration(milliseconds: 500));
        emitFailure(failureResponse: "Error please try again");
      }
    } catch (e) {
      emitFailure(failureResponse: e);
    }
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ComfirmTask())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.replay),
              label: Text('List Checkin'),
            ),
          ],
        ),
      ),
    );
  }
}

class ModelUpdateTask {
  String task_weight;
  bool range;

  ModelUpdateTask({this.task_weight, this.range});
}
