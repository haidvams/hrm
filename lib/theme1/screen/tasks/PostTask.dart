import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class PostTask extends StatelessWidget {
  const PostTask({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AllFieldsForm();
  }
}

class AllFieldsFormBloc extends FormBloc<String, String> {
  final subject = TextFieldBloc();

  final boolean1 = BooleanFieldBloc();

  final halfcheck = BooleanFieldBloc();

  final type = SelectFieldBloc(
    items: ['Privilege Leave', 'Leave Without Pay'],
  );

  final fromdate = InputFieldBloc<DateTime, Object>();
  final todate = InputFieldBloc<DateTime, Object>();
  final halfday = InputFieldBloc<DateTime, Object>();
  final bool _isVisible = false;

  final dateAndTime1 = InputFieldBloc<DateTime, Object>();

  final time1 = InputFieldBloc<TimeOfDay, Object>();

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      subject,
      boolean1,
      halfcheck,
      type,
      fromdate,
      todate,
      halfday,
      dateAndTime1,
      time1,
    ]);
  }

  addErrors() {
    if (type.value == null){
      type.addFieldError('Please select!');
      return false;
    }
    if (fromdate.value == null){
      fromdate.addFieldError('Please select!');
      return false;
    }
    if (todate.value == null){
      todate.addFieldError('Please select!');
      return false;
    }
    if (halfcheck.value){
      if(fromdate.value != todate.value && halfday.value == null){
        halfday.addFieldError('Please select!');
        return false;
      }
    }
    if(fromdate.value.millisecondsSinceEpoch > todate.value.millisecondsSinceEpoch ){
      fromdate.addFieldError('Please select less than to date!');
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
      "half_day": halfday.value != null ? "1" : "0",
      "status": "Open",
      "posting_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "leave_type": type.value,
      "from_date": DateFormat('yyyy-MM-dd').format(fromdate.value),
      "half_day_date": halfday.value == null ? "" : DateFormat('yyyy-MM-dd')
          .format(halfday.value),
      "to_date": DateFormat('yyyy-MM-dd').format(todate.value),
      "description": subject.value == null ? "" : subject.value
    };


    try {
      User user = await db.getUser();
      var res = await api.postleaveDraft(
          '/api/resource/Leave Application', user.sid, dataBody);
      if (res == true) {
        await Future<void>.delayed(Duration(milliseconds: 500));
        emitSuccess(canSubmitAgain: true);
      } else {
        await Future<void>.delayed(Duration(milliseconds: 500));
        emitFailure(failureResponse: "Double date please try again");
      }
    } catch (e) {
      emitFailure(failureResponse: e);
    }
  }
}

class AllFieldsForm extends StatefulWidget {
  @override
  _AllFieldsFormState createState() => _AllFieldsFormState();
}

class _AllFieldsFormState extends State<AllFieldsForm> {
  bool visibilityHalf = false;
  bool visibilityType = false;

  Future<T1ModelLeaveDetail> _leaveAvali;

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
        '/api/method/erpnext.hr.doctype.leave_application.leave_application.get_leave_details',user.sid,
        type,
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

  void conditionfields(formBloc) {
    formBloc.halfcheck.onValueChanges(
      onData: (previous, current) async* {
        if (current.value) {
          if (formBloc.fromdate.value == formBloc.todate.value) {
            formBloc.halfday.updateValue(formBloc.fromdate.value);
          } else {
            setState(() {
              visibilityHalf = true;
            });
          }
        } else {
          setState(() {
            visibilityHalf = false;
          });
        }
      },
    );
    formBloc.type.onValueChanges(
      onData: (previous, current) async* {
        if (current.value != null) {
          setState(() {
            _leaveAvali = getDetailLeave(current.value);
            visibilityType = true;
          });
        } else {
          setState(() {
            visibilityType = false;
          });
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllFieldsFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);
          conditionfields(formBloc);

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
                title: Text('New Task'),
                backgroundColor: Color(0xFF3281FF),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      var check = await formBloc.addErrors();
                      if(check){
                        formBloc.submit();
                      }
                    },
                  )
                ],
              ),
              body: FormBlocListener<AllFieldsFormBloc, String, String>(
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
                        Visibility(
                          child: FutureBuilder<T1ModelLeaveDetail>(
                            future: _leaveAvali,
                            builder: (context, data) {
                              if (data.hasData) {
                                return Column(
                                  children: <Widget>[
                                    text(data.data.type,
                                        textColor: t1TextColorPrimary,
                                        fontSize: textSizeNormal,
                                        fontFamily: fontMedium),
                                    text(
                                        "Total: " +
                                            data.data.total_leaves.toString() +
                                            "Days",
                                        textColor: t1_colorPrimary,
                                        fontSize: textSizeMedium,
                                        fontFamily: fontMedium),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: view(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        counter(
                                            data.data.expired_leaves.toString(),
                                            "expired"),
                                        counter(
                                            data.data.leaves_taken.toString(),
                                            "taken"),
                                        counter(
                                            data.data.pending_leaves.toString(),
                                            "pending"),
                                        counter(
                                            data.data.remaining_leaves
                                                .toString(),
                                            "remaining"),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                );
                              } else if (data.hasError) {
                                return Text("${data.error}");
                              }
                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
                          ),
                          visible: visibilityType,
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.subject,
                          decoration: InputDecoration(
                            labelText: 'subject',
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
                        SwitchFieldBlocBuilder(
                          booleanFieldBloc: formBloc.halfcheck,
                          body: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Half Day'),
                          ),
                        ),
                        Visibility(
                          child: DateTimeFieldBlocBuilder(
                            dateTimeFieldBloc: formBloc.halfday,
                            format: DateFormat('dd-mm-yyyy'),
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            decoration: InputDecoration(
                              labelText: 'Half Day Date',
                              prefixIcon: Icon(Icons.calendar_today),
                              helperText: 'Date',
                            ),
                          ),
                          visible: visibilityHalf,
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

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
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
              onPressed: () =>
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => AllFieldsForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/T1EmployeeLeave");
              },
              icon: Icon(Icons.replay),
              label: Text('View Leave'),
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

  T1ModelLeaveDetail({this.total_leaves,
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
