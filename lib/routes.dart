import 'package:flutter/material.dart';
import 'package:hrm/theme1/screen/Attendance.dart';
import 'package:hrm/theme1/screen/attendance/BeaconScanner.dart';
import 'package:hrm/theme1/screen/leaves/T1EmployeeLeave.dart';
import 'package:hrm/theme1/screen/leaves/T1LeaveApplication.dart';
import 'package:hrm/theme1/screen/T1ListCategories.dart';
import 'package:hrm/theme1/screen/T1Listing.dart';
import 'package:hrm/theme1/screen/T1Loading.dart';
import 'package:hrm/theme1/screen/T1Login.dart';
import 'package:hrm/theme1/T1Profile.dart';
import 'package:hrm/theme1/screen/T1Signup.dart';
import 'package:hrm/theme1/screen/projects/T1Project.dart';
import 'package:hrm/theme1/screen/tasks/ComfirmTask.dart';
import 'package:hrm/theme1/screen/tasks/T1Task.dart';
import 'package:hrm/theme1/screen/timetracking/ListTimeTracking.dart';
import 'theme1/screen/T1Dashboard.dart';

final routes = {
  '/' : (BuildContext context)=>T1Loading(),
  '/T1Login' : (BuildContext context)=>T1Login(),
  '/T1Signup' : (BuildContext context)=>T1Signup(),
  '/T1Dashboard' : (BuildContext context)=>T1Dashboard(),
  '/T1EmployeeAttendance' : (BuildContext context)=>T1EmployeeAttendance(),
  '/T1Project' : (BuildContext context)=>T1Project(),
  '/T1Task' : (BuildContext context)=>T1Task(),
  '/T1EmployeeLeave' : (BuildContext context)=>T1EmployeeLeave(),
  '/T1LeaveApplication' : (BuildContext context)=>T1LeaveApplication(),
  '/T1Listing' : (BuildContext context)=>T1Listing(),
  '/T1ListCategories' : (BuildContext context)=>T1ListCategories(),
  '/T1Profile' : (BuildContext context)=>T1Profile(),
  '/ComfirmTask' : (BuildContext context)=>ComfirmTask(),
  '/ListTimeTracking' : (BuildContext context)=>ListTimeTracking(),
  '/BeaconScanner' : (BuildContext context)=>BeaconScanner(),


};