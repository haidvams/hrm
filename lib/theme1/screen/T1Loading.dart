import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrm/main/data/auth.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:hrm/theme1/utils/login_presenter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class T1Loading extends StatefulWidget {
  static var tag = "/T1Loading";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<T1Loading>
    implements LoginScreenContract, AuthStateListener {
  LoginScreenPresenter _presenter;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: t1_app_background,
        body: Center(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [t1_app_background, t1_textColorSecondary])),
          child: Center(
            child: Image.asset(t1_logo_mini, height: 100, width: 100),
          ),
        )));
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Future<void> onAuthStateChanged(AuthState state) async {
    // TODO: implement onAuthStateChanged
    if (state == AuthState.LOGGED_IN) {
      User user = await db.getUser();
      await http.post(RestDatasource.LOGINED_URL, headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': user.sid.trim(),
      }).then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode > 400 || json == null) {
          api
              .login(user.username, user.password)
              .then((User user_update) async {
            await db.update(user_update, user.id);
            Navigator.of(context).pushReplacementNamed("/T1Dashboard");
          }).catchError((Object error) {
            _showSnackBar(error);
            Future.delayed(const Duration(milliseconds: 5000), () {
              exit(0);
            });
          });
        } else {
          Navigator.of(context).pushReplacementNamed("/T1Dashboard");
        }
      }).catchError((error) {
        _showSnackBar("lỗi kết nối server hoặc chưa bật mạng");
        Future.delayed(const Duration(milliseconds: 5000), () {
          exit(0);
        });
      });
    } else {
      Navigator.of(context).pushReplacementNamed("/T1Login");
    }
  }

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
  }

  @override
  void onLoginSuccess(User user) {
    // TODO: implement onLoginSuccess
  }
}
