import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
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

  var db = new DatabaseHelper();

  FormGroup buildForm() =>
      fb.group(<String, dynamic>{
        'leave_type': FormControl<String>(validators: [Validators.required]),
        'half_day': FormControl<bool>(value: false),
        'from_date': FormControl<DateTime>(value: DateTime.now()),
        'to_date': FormControl<DateTime>(value: DateTime.now()),
        'half_day_date': FormControl<DateTime>(validators: [Validators.required]),
        'description': FormControl<String>(validators: [Validators.required]),

      });



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
}
