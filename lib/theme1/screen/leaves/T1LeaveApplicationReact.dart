import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/AppConstant.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_forms_widgets/reactive_forms_widgets.dart';

class T1LeaveApplicationReact extends StatefulWidget {
  @override
  _T1LeaveApplicationState createState() => _T1LeaveApplicationState();
}

class _T1LeaveApplicationState extends State<T1LeaveApplicationReact> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  RestDatasource api = new RestDatasource();
  bool _infoType = false;
  var db = new DatabaseHelper();
  Map _pLeave = {};

  FormGroup buildForm() => fb.group(<String, dynamic>{
        'leave_type': FormControl<String>(
          validators: [Validators.required, _getType],
        ),
        'half_day': FormControl<bool>(
          value: false,
          validators: [_halfDayCheck],
        ),
        'from_date': FormControl<DateTime>(value: DateTime.now()),
        'to_date': FormControl<DateTime>(value: DateTime.now()),
        'half_day_date':
            FormControl<DateTime>(validators: [Validators.required]),
        'description': FormControl<String>(validators: [Validators.required]),
      });

  /// Validates that control's value must be `true`
  Map<String, dynamic> _getType(AbstractControl<dynamic> control) {
    if (control.value == "Nghỉ không lương") {
      setState(() {
        _infoType = false;
      });
    } else if (control.value == "Nghỉ phép") {
      _getLeaveAllocation(control);
    } else {
      return {'required': true};
    }
  }

  /// Validates that control's value must be `true`
  Map<String, dynamic> _halfDayCheck(AbstractControl<dynamic> control) {
    if (control.value == true) {

      print(buildForm().controls["from_date"].value);
      if (buildForm().controls["from_date"].value ==
          buildForm().controls["to_date"].value) {

      }
    }
  }

  _getLeaveAllocation(AbstractControl<dynamic> control) async {
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
    if (data.isNotEmpty && !data.containsKey('error')) {
      if ((data["message"]["leave_allocation"].isNotEmpty)) {
        setState(() {
          _pLeave = data["message"]["leave_allocation"]["Privilege Leave"];
          _infoType = true;
        });
      } else {
        control.setErrors({'privilegeLeave': true});
      }
    } else {
      control.setErrors({'privilegeLeave': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Xin nghỉ phép'),
        backgroundColor: Color(0xFF3281FF),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.save,
        //       color: Colors.white,
        //     ),
        //     onPressed: () async {
        //
        //     },
        //   )
        // ],
      ),
      body: Container(
        // margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: ReactiveFormBuilder(
            form: buildForm,
            builder: (context, form, child) {
              return Column(
                children: [
                  const SizedBox(height: 30),
                  Visibility(
                    child: Column(
                      children: <Widget>[
                        text("Đặc quyền nghỉ",
                            textColor: t1TextColorPrimary,
                            fontSize: textSizeNormal,
                            fontFamily: fontMedium),
                        text(
                            "Tổng cộng: " +
                                _pLeave["total_leaves"].toString() +
                                " Ngày",
                            textColor: t1_colorPrimary,
                            fontSize: textSizeMedium,
                            fontFamily: fontMedium),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: view(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            counter(_pLeave["expired_leaves"].toString(),
                                "Quá hạn"),
                            counter(
                                _pLeave["leaves_taken"].toString(), "Đã dùng"),
                            counter(_pLeave["pending_leaves"].toString(),
                                "Chờ duyệt"),
                            counter(_pLeave["remaining_leaves"].toString(),
                                "Còn lại"),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                    visible: _infoType,
                  ),
                  const SizedBox(height: 8),
                  ReactiveDropdownSearch(
                    formControlName: 'leave_type',
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    mode: ReactiveDropdownSearchMode.MENU,
                    hint: 'Lựa chọn loại nghỉ phép',
                    showSelectedItem: true,
                    items: ['Nghỉ phép', 'Nghỉ không lương'],
                    label: 'Loại phép *',
                    showClearButton: true,
                    validationMessages: (control) => {
                      'required': 'Không được để trống',
                      'privilegeLeave': 'Bạn Chưa được gán ngày nghỉ'
                    },
                  ),
                  const SizedBox(height: 8),
                  ReactiveDateTimePicker(
                    formControlName: 'from_date',
                    decoration: const InputDecoration(
                      labelText: 'Từ ngày',
                      border: OutlineInputBorder(),
                      helperText: '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    valueAccessor: DateTimeValueAccessor(
                      dateTimeFormat: DateFormat('dd/mm/yyyy'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveDateTimePicker(
                    formControlName: 'to_date',
                    decoration: const InputDecoration(
                      labelText: 'Đến ngày',
                      border: OutlineInputBorder(),
                      helperText: '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    valueAccessor: DateTimeValueAccessor(
                      dateTimeFormat: DateFormat('dd/mm/yyyy'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ReactiveSwitch(formControlName: 'half_day'),
                      const Text('Nửa ngày')
                    ],
                  ),
                  const SizedBox(height: 8),
                  ReactiveDateTimePicker(
                    formControlName: 'half_day_date',
                    decoration: const InputDecoration(
                      labelText: 'Chọn ngày',
                      border: OutlineInputBorder(),
                      helperText: '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    valueAccessor: DateTimeValueAccessor(
                      dateTimeFormat: DateFormat('dd/mm/yyyy'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveTextField(
                    formControlName: 'description',
                    decoration: const InputDecoration(
                      labelText: 'Lý do',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    validationMessages: (errors) => {
                      ValidationMessage.required: 'Không được để trống',
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Nộp đơn'),
                    onPressed: () {
                      if (form.valid) {
                        print(form.value);
                      } else {
                        form.markAllAsTouched();
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
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
}
