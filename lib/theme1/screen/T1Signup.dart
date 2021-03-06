import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class T1Signup extends StatelessWidget {
  static var tag = "/T1SignUp";
  String _fullname, _phone, _password;

  void _submit() {
    print("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(t1_ic_ring, height: 100, width: 100),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[formHeading(t1_lbl_sign_up_header)],
                ),
                SizedBox(height: 40),
                editTextStyle(t1_hint_fullName, _fullname, isPassword: false),
                SizedBox(height: 16),
                editTextStyle(t1_email_phone_no, _phone, isPassword: false),
                SizedBox(height: 16),
                editTextStyle(t1_hint_password, _password, isPassword: true),
                SizedBox(height: 16),
                editTextStyle(t1_hint_re_password, _password, isPassword: true),
                SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: shadowButton(t1_lbl_sign_up, _submit)),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    text(t1_lbl_already_have_account,
                        textColor: t1_textColorSecondary,
                        fontSize: textSizeLargeMedium),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(context, "/T1SignIn");
                      },
                      child: text(t1_lbl_sign_in,
                          fontFamily: fontMedium, textColor: t1_blue),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
