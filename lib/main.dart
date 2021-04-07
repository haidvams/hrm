import 'package:flutter/material.dart';
// import 'package:hrm/pages/home_page.dart';
// import 'package:hrm/pages/login_page.dart';
import 'package:hrm/routes.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HRM",
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: routes,
    );
  }
}
