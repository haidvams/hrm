import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/DialogPopup.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_forms_widgets/reactive_forms_widgets.dart';

class PostChangePassWord extends StatefulWidget {
  @override
  _PostChangePassWord createState() => _PostChangePassWord();
}

class _PostChangePassWord extends State<PostChangePassWord> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  RestDatasource api = new RestDatasource();
  List<dynamic> _projects = [];
  List<dynamic> _bucketProjects = [];
  List<dynamic> _users = [];

  FormGroup buildForm() => fb.group(<String, dynamic>{
        'subject': FormControl<String>(validators: [Validators.required]),
        'project': FormControl<String>(validators: [Validators.required]),
        'project_bucket': FormControl<String>(
          validators: [Validators.required],
        ),
        'report_to': FormControl<String>(
          validators: [Validators.required],
        ),
        'assign_by': FormControl<String>(
          validators: [Validators.required],
        ),
        'task_weight': FormControl<double>(value: 5),
        'range': FormControl<String>(value: "1"),
        'exp_end_date': FormControl<DateTime>(value: DateTime.now())
      });

  getData() async {
    List _projectsModel = await api.getDataPublic(
        '/api/resource/Project?fields=["name","project_name"]&limit_page_length=0');

    List _bucketProjectsModel = await api.getDataPublic(
        '/api/resource/Project%20Bucket?fields=["name_bucket"]&limit_page_length=0');

    List _usersModel = await api.getDataPublic(
        '/api/resource/Employee?fields=["name","employee_name","user_id"]&filters=[["Employee","user_id","not like",null]]&limit_page_length=0');
    setState(() {
      _projects = _projectsModel;
      _bucketProjects = _bucketProjectsModel;
      _users = _usersModel;
    });
  }

  postData(Map args) async {
    String _subject = args['subject'];
    String _project = _projects
        .where(
            (item) => item['project_name'] == args['project'] ?? item['name'])
        .toList()
        .first['name'];

    String _project_bucket = args['project_bucket'];

    String _report_to = _users
        .where((item) =>
            item['employee_name'] == args['report_to'] ?? item['user_id'])
        .toList()
        .first['user_id'];
    String _assign_by = _users
        .where((item) =>
            item['employee_name'] == args['assign_by'] ?? item['user_id'])
        .toList()
        .first['user_id'];
    String _task_weight = args['task_weight'].toString();
    String _exp_end_date = args['exp_end_date'].toString();
    String _range = args['range'];

    var postData = {
      "subject": _subject,
      "project": _project,
      "project_bucket": _project_bucket,
      "report_to": _report_to,
      "assign_by": _assign_by,
      "range": _range,
      "task_weight": _task_weight.toString(),
      "exp_end_date": _exp_end_date
    };
    Map _check = await api.postFormDataPublic('/api/resource/Task', postData);
    if (_check.isNotEmpty && !_check.containsKey('error')) {
      LoadingDialog.hide(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => SuccessScreen(router : "/T1Dashboard")));
    } else {
      LoadingDialog.hide(context);
      _showSnackBar("Có lỗi hãy thử lại");
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Tạo Công việc mới'),
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
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: ReactiveFormBuilder(
            form: buildForm,
            builder: (context, form, child) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  ReactiveTextField(
                    formControlName: 'subject',
                    decoration: const InputDecoration(
                      labelText: 'Tên công việc',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    validationMessages: (errors) => {
                      ValidationMessage.required: 'Không được để trống',
                    },
                  ),
                  const SizedBox(height: 18),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'project',
                    mode: ReactiveDropdownSearchMode.BOTTOM_SHEET,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: _projects.isNotEmpty
                        ? _projects
                            .map((item) => item["project_name"].toString())
                            .toList()
                        : [],
                    label: 'Dự án',
                    hint: "-- Chọn dự án ---",
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Dự án',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'project_bucket',
                    mode: ReactiveDropdownSearchMode.BOTTOM_SHEET,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: _bucketProjects.isNotEmpty
                        ? _bucketProjects
                            .map((item) => item["name_bucket"].toString())
                            .toList()
                        : [],
                    label: 'Nhóm việc',
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Nhóm việc',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'report_to',
                    mode: ReactiveDropdownSearchMode.BOTTOM_SHEET,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: _users.isNotEmpty
                        ? _users
                            .map((item) => item["employee_name"].toString())
                            .toList()
                        : [],
                    label: 'Báo cáo cho',
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Người nhận báo cáo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'assign_by',
                    mode: ReactiveDropdownSearchMode.BOTTOM_SHEET,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: _users.isNotEmpty
                        ? _users
                            .map((item) => item["employee_name"].toString())
                            .toList()
                        : [],
                    label: 'Giao việc cho',
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Người nhận việc',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveTouchSpin<double>(
                    formControlName: 'task_weight',
                    min: 1,
                    max: 100,
                    step: 0.5,
                    textStyle: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      labelText: 'Thời lượng(H)',
                      helperText: '',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReactiveSegmentedControl(
                    decoration: const InputDecoration(
                      labelText: 'Phạm vi',
                      border: OutlineInputBorder(),
                      helperText: '',
                    ),
                    padding: const EdgeInsets.all(0),
                    formControlName: 'range',
                    children: {
                      "1": const Text('Trong'),
                      "0": const Text('Ngoài'),
                    },
                  ),
                  const SizedBox(height: 8),
                  ReactiveDateTimePicker(
                    formControlName: 'exp_end_date',
                    decoration: const InputDecoration(
                      labelText: 'Ngày kết thúc',
                      border: OutlineInputBorder(),
                      helperText: '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Tạo Công Việc'),
                    onPressed: () {
                      if (form.valid) {
                        LoadingDialog.show(context);
                        postData(form.value);
                      } else {
                        form.markAllAsTouched();
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
