import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/theme1/screen/attendance/T1Checkin.dart';

class BeaconScanner extends StatefulWidget {
  @override
  _BeaconScanner createState() => _BeaconScanner();
}

class _BeaconScanner extends State<BeaconScanner> {
  String _beaconResult = 'Get ID device service...';
  int _nrMessaggesReceived = 0;
  var isRunning = false;
  String _uuid;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  _getIdAttendance() async {
    dynamic id = await api.getDataPublic(
        '/api/resource/Attendance%20device?fields=["uuid"]&limit_page_length=1');

    if (id.isNotEmpty) {
      setState(() {
        _uuid = id.first["uuid"].toString();
        _beaconResult = 'Looking for the device...';
      });
      initPlatformState();
      await BeaconsPlugin.startMonitoring;
    } else {
      _showSnackBar("Errors server HRM to get ID devece checkin");
    }
  }

  _onCheckinSubmit() async {
    String _deviceId = await _getId();
    Map dataBody = await {"log_type": "IN", "device_id": _deviceId};

    try {
      User user = await db.getUser();
      var res = await api.postPrivateAll(
          '/api/resource/Employee%20Checkin', user.sid, dataBody);
      if (res == true) {
        await Future<void>.delayed(Duration(milliseconds: 500));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => T1Checkin()));
      } else {
        await Future<void>.delayed(Duration(milliseconds: 500));
        Navigator.pop(context);
      }
    } catch (e) {
      print("err");
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void initState() {
    super.initState();
    _getIdAttendance();
  }

  @override
  void dispose() {
    beaconEventsController.close();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      // await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);
    //ios must add uuid you want to scan
    await BeaconsPlugin.addRegion(
        "ESP32", _uuid);

    beaconEventsController.stream.listen(
        (data) async {
          if (data.isNotEmpty) {
            if (_uuid == jsonDecode(data)["uuid"].toString().toLowerCase()) {
              await BeaconsPlugin.stopMonitoring;
              setState(() {
                _beaconResult = "Đang checkin ...";
              });
              Future.delayed(const Duration(seconds: 1), () => "1");
              _onCheckinSubmit();
            } else {
              setState(() {
                _nrMessaggesReceived++;
              });
            }
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    // Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring;
          setState(() {
            isRunning = true;
          });
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring;
      setState(() {
        isRunning = true;
      });
    }

    if (!mounted) return;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit Checkin'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () async {
                  try {
                    await BeaconsPlugin.stopMonitoring;
                  } catch (e) {
                    // _showSnackBar(e.toString());
                  }
                  await Future<void>.delayed(Duration(milliseconds: 500));

                  return Navigator.of(context).pop(true);
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Checkin'),
          backgroundColor: Color(0xFF3281FF),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$_beaconResult'),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Text('$_nrMessaggesReceived'),
              SizedBox(
                height: 20.0,
              ),
              // Visibility(
              //   visible: isRunning,
              //   child: RaisedButton(
              //     onPressed: () async {
              //       if (Platform.isAndroid) {
              //         await BeaconsPlugin.stopMonitoring;
              //
              //         setState(() {
              //           isRunning = false;
              //         });
              //       }
              //     },
              //     child: Text('Stop Scanning', style: TextStyle(fontSize: 20)),
              //   ),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // Visibility(
              //   visible: !isRunning,
              //   child: RaisedButton(
              //     onPressed: () async {
              //       initPlatformState();
              //       await BeaconsPlugin.startMonitoring;
              //
              //       setState(() {
              //         isRunning = true;
              //         _beaconResult = "Đang tìm device...";
              //       });
              //     },
              //     child: Text('Start Scanning', style: TextStyle(fontSize: 20)),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
