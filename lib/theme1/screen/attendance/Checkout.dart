import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/screen/attendance/T1Checkin.dart';

class Checkout {

  String id_device;

  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

  onCheckinClick(String type) async {
    String _deviceId = await _getId();
    Map dataBody = await {"log_type": type, "device_id": _deviceId};

    try {
      User user = await db.getUser();
      var res = await api.postPrivateAll(
          '/api/resource/Employee%20Checkin', user.sid, dataBody);
      if (res == true) {
        await Future<void>.delayed(Duration(milliseconds: 500));
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => T1Checkin()));
      } else {
        await Future<void>.delayed(Duration(milliseconds: 500));
        // Navigator.pop(context);
      }
    } catch (e) {
      print("err");
    }
  }


  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }


}


