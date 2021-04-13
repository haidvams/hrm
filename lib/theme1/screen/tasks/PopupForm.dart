import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class PopupForm extends StatefulWidget {
  @override
  _PopupFormState createState() => _PopupFormState();
}

class _PopupFormState extends State<PopupForm> {

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  Future<T1ModelLeaveDetail> getDetailLeave(String type) async {
    User user = await db.getUser();
    String nameid = await api.getNameId(user.sid, "/api/resource/Employee/");
    var datapost = {
      'employee': nameid,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
    var data = await api.getleaveAvalible(
        '/api/method/erpnext.hr.doctype.leave_application.leave_application.get_leave_details',
        user.sid,
        datapost);
    return data == null ? data : T1ModelLeaveDetail.fromJson(data);
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
    return BlocProvider(
      create: (context) => _PopupFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<_PopupFormBloc>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Checkin Form'),
                backgroundColor: Color(0xFF3281FF),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      LoadingDialog.show(context);
                    },
                  )
                ],
              ),
              body: FormBlocListener<_PopupFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SuccessScreen()));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse)));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        DropdownFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.type,
                          decoration: InputDecoration(
                            labelText: 'Checkin Type',
                            prefixIcon: Icon(Icons.sentiment_satisfied),
                          ),
                          itemBuilder: (context, value) => value,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.device_id,
                          decoration: InputDecoration(
                            labelText: 'Device ID',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        SwitchFieldBlocBuilder(
                          booleanFieldBloc: formBloc.skip_auto_attendance,
                          body: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Skip Auto attendance'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class _PopupFormBloc extends FormBloc<String, String> {
  final device_id = TextFieldBloc();

  final skip_auto_attendance = BooleanFieldBloc();

  final type = SelectFieldBloc(
    items: ['IN', 'OUT'],
  );
  final halfday = InputFieldBloc<DateTime, Object>();

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  _PopupFormBloc() {
    addFieldBlocs(fieldBlocs: [
      device_id,
      skip_auto_attendance,
      type,
      halfday,
    ]);
  }

  addErrors() {
    if (type.value == null) {
      type.addFieldError('Please select!');
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
      "skip_auto_attendance": halfday.value != null ? "1" : "0",
      "log_type": type.value,
      "device_id": device_id.value == null ? "" : device_id.value
    };

    try {
      User user = await db.getUser();
      var res = await api.postPrivateAll(
          '/api/resource/Employee%20Checkin', user.sid, dataBody);
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




class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1.2;

    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: halfMediaWidth,
            height: 500,
            padding: EdgeInsets.all(12.0),
            child: BlocProvider(
              create: (context) => _PopupFormBloc(),
              child: Builder(
                builder: (context) {
                  final formBloc = BlocProvider.of<_PopupFormBloc>(context);
                  return Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text('Checkin Form'),
                        backgroundColor: Color(0xFF3281FF),
                        actions: [
                          IconButton(
                            icon: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              LoadingDialog.show(context);
                            },
                          )
                        ],
                      ),
                      body: FormBlocListener<_PopupFormBloc, String, String>(
                        onSubmitting: (context, state) {
                          LoadingDialog.show(context);
                        },
                        onSuccess: (context, state) {
                          LoadingDialog.hide(context);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => SuccessScreen()));
                        },
                        onFailure: (context, state) {
                          LoadingDialog.hide(context);

                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text(state.failureResponse)));
                        },
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                DropdownFieldBlocBuilder<String>(
                                  selectFieldBloc: formBloc.type,
                                  decoration: InputDecoration(
                                    labelText: 'Checkin Type',
                                    prefixIcon: Icon(Icons.sentiment_satisfied),
                                  ),
                                  itemBuilder: (context, value) => value,
                                ),
                                TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.device_id,
                                  decoration: InputDecoration(
                                    labelText: 'Device ID',
                                    prefixIcon: Icon(Icons.text_fields),
                                  ),
                                ),
                                SwitchFieldBlocBuilder(
                                  booleanFieldBloc: formBloc.skip_auto_attendance,
                                  body: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Skip Auto attendance'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
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
                  MaterialPageRoute(builder: (_) => PopupForm())),
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


class T1ModelLeaveDetail {
  String type;
  double total_leaves;
  double expired_leaves;
  int leaves_taken;
  double pending_leaves;
  double remaining_leaves;

  T1ModelLeaveDetail(
      {this.total_leaves,
        this.type,
        this.expired_leaves,
        this.leaves_taken,
        this.pending_leaves,
        this.remaining_leaves});

  factory T1ModelLeaveDetail.fromJson(Map<String, dynamic> json) {
    return T1ModelLeaveDetail(
      type: json['type'] ??= t1_lbl_Empty,
      total_leaves: json['total_leaves'] ??= t1_lbl_Empty,
      expired_leaves: json['expired_leaves'] ??= t1_lbl_Empty,
      leaves_taken: json['leaves_taken'] ??= t1_lbl_Empty,
      pending_leaves: json['pending_leaves'] ??= t1_lbl_Empty,
      remaining_leaves: json['remaining_leaves'] ??= t1_lbl_Empty,
    );
  }
}
