import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/auth.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/utils/login_presenter.dart';

class T1Login extends StatefulWidget {
  static var tag = "/T1SignIn";

  @override
  _T1LoginState createState() => _T1LoginState();

}

class _T1LoginState extends State<T1Login> implements LoginScreenContract , AuthStateListener{

  bool rememberMe = false;

  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;
  RestDatasource api = new RestDatasource();

  LoginScreenPresenter _presenter;

  _T1LoginState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {


    final form = formKey.currentState;

    if (form.validate()) {
      LoadingDialog.show(context);
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    LoadingDialog.hide(context);
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) async {

    if(state == AuthState.LOGGED_IN){
      Navigator.of(_ctx).pushReplacementNamed("/T1Dashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset(t1_logo_full, height: 100, width: 100),
                SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[formHeading("Đăng nhập")]),
                SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: TextFormField(
                            style:
                            TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                              hintText: "Email",
                              filled: true,
                              fillColor: t1_edit_text_background,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                const BorderSide(color: t1_edit_text_background, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                const BorderSide(color: t1_edit_text_background, width: 0.0),
                              ),
                            ),
                            onSaved: (val) => _username = val,
                            validator: (val) {
                              if(val.isEmpty){
                                return "Enter your email";
                              }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                                return "Enter your email again";
                              }
                              return null;

                            },
                          )),
                      SizedBox(height: 16),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: TextFormField(
                            style:
                            TextStyle(fontSize: textSizeLargeMedium, fontFamily: fontRegular),
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                              hintText: "Mật khẩu",
                              filled: true,
                              fillColor: t1_edit_text_background,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                const BorderSide(color: t1_edit_text_background, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                const BorderSide(color: t1_edit_text_background, width: 0.0),
                              ),
                            ),
                            onSaved: (val) => _password = val,
                          )),
                      SizedBox(height: 8),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      //   child: CheckboxListTile(
                      //     title: text(t1_lbl_remember, textColor: t1TextColorPrimary),
                      //     value: rememberMe,
                      //     onChanged: (newValue) {
                      //       rememberMe = newValue;
                      //       setState(() {});
                      //     },
                      //     controlAffinity: ListTileControlAffinity.leading,
                      //   ),
                      // ),
                      SizedBox(height: 8),
                      Padding(
                          padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
                          child: Material(
                              elevation: 2,
                              shadowColor: Colors.deepOrangeAccent[200],
                              borderRadius: new BorderRadius.circular(40.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: MaterialButton(
                                  child: text("Đăng Nhập",
                                      fontSize: textSizeLargeMedium,
                                      textColor: t1_white,
                                      fontFamily: fontMedium),
                                  textColor: t1_white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(40.0)),
                                  color: t1_colorPrimary,
                                  onPressed: _submit,
                                ),
                              )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     GestureDetector(
                //       onTap: () { print("Container was tapped"); },
                //       child: text(t1_lbl_forgot_password, textColor: t1_textColorSecondary, fontSize: textSizeLargeMedium),
                //     ),
                //     SizedBox(width: 8),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.pushNamed(context, "/T1Signup");
                //       },
                //       child: text(t1_lbl_sign_up, fontFamily: fontMedium, textColor: t1_blue),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(t1_lbl_sign_noti);
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
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
