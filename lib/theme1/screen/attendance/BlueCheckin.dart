// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:device_info/device_info.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
// import 'package:flutter_countdown_timer/current_remaining_time.dart';
// import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
// import 'package:hrm/main/data/database_helper.dart';
// import 'package:hrm/main/data/rest_data.dart';
// import 'package:hrm/main/models/user.dart';
// import 'package:hrm/theme1/screen/attendance/T1Checkin.dart';
//
// class BlueCheckin extends StatefulWidget {
//   @override
//   _FlutterBlueAppState createState() => _FlutterBlueAppState();
// }
//
// class _FlutterBlueAppState extends State<BlueCheckin> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: StreamBuilder<BluetoothState>(
//             stream: FlutterBlue.instance.state,
//             initialData: BluetoothState.unknown,
//             builder: (c, snapshot) {
//               final state = snapshot.data;
//               if (state == BluetoothState.on) {
//                 return FindDevicesScreen();
//               }
//               return BluetoothOffScreen(state: state);
//             }));
//   }
// }
//
// class BluetoothOffScreen extends StatelessWidget {
//   const BluetoothOffScreen({Key key, this.state}) : super(key: key);
//
//   final BluetoothState state;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF3281FF),
//       appBar: AppBar(
//         title: Text('Checkin'),
//         backgroundColor: Color(0xFF3281FF),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Icon(
//               Icons.bluetooth_disabled,
//               size: 200.0,
//               color: Colors.white54,
//             ),
//             Text(
//               'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
//               style: Theme.of(context)
//                   .primaryTextTheme
//                   .subhead
//                   .copyWith(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FindDevicesScreen extends StatefulWidget {
//   @override
//   _FindDevicesScreenState createState() => _FindDevicesScreenState();
// }
//
// class _FindDevicesScreenState extends State<FindDevicesScreen> {
//   String id_device;
//
//   final scaffoldKey = new GlobalKey<ScaffoldState>();
//
//
//   RestDatasource api = new RestDatasource();
//   var db = new DatabaseHelper();
//
//   CountdownTimerController controller;
//   int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
//
//   void onEnd() {
//     Navigator.pop(context);
//   }
//
//   bool _isVisibleLoading = true;
//   bool _isVisibleCheckin = false;
//
//   onCheckinClick(String type) async {
//     String _deviceId = await _getId();
//     Map dataBody = await {"log_type": type, "device_id": _deviceId};
//
//     try {
//       User user = await db.getUser();
//       var res = await api.postPrivateAll(
//           '/api/resource/Employee%20Checkin', user.sid, dataBody);
//       if (res == true) {
//         await Future<void>.delayed(Duration(milliseconds: 500));
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => T1Checkin()));
//       } else {
//         await Future<void>.delayed(Duration(milliseconds: 500));
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       print("err");
//     }
//   }
//
//   _getIdAttendance() async {
//     dynamic id = await api.getDataPublic(
//         '/api/resource/Attendance%20device?fields=["id_device"]&limit_page_length=1');
//     if (id.isNotEmpty) {
//       setState(() {
//         id_device = id.first["id_device"].toString();
//       });
//     } else {
//       throw ("Erorres get device");
//     }
//   }
//
//   _blueScan() {
//     FlutterBlue flutterBlue = FlutterBlue.instance;
//     flutterBlue.startScan(timeout: Duration(seconds: 60));
//     flutterBlue.scanResults.listen((results) async {
//       for (ScanResult r in results) {
//
//         if (r.device.id != null && r.device.id.toString() == id_device) {
//           flutterBlue.stopScan();
//
//           // try {
//           //   await r.device.connect();
//           // } catch (e) {
//           //   if (e.code != 'already_connected') {
//           //     _showSnackBar("Error connect , please try again");
//           //   }
//           // } finally {
//           //   await r.device.disconnect();
//           // }
//
//           setState(() {
//             controller.disposeTimer();
//             _isVisibleCheckin = true;
//             _isVisibleLoading = false;
//           });
//         }
//       }
//     });
//   }
//
//   void _showSnackBar(String text) {
//     scaffoldKey.currentState
//         .showSnackBar(new SnackBar(content: new Text(text)));
//   }
//
//   Future<String> _getId() async {
//     var deviceInfo = DeviceInfoPlugin();
//     if (Platform.isIOS) { // import 'dart:io'
//       var iosDeviceInfo = await deviceInfo.iosInfo;
//       return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//     } else {
//       var androidDeviceInfo = await deviceInfo.androidInfo;
//       return androidDeviceInfo.androidId; // unique ID on Android
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _getIdAttendance();
//     _blueScan();
//     controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: Text('Checkin'),
//         backgroundColor: Color(0xFF3281FF),
//         centerTitle: true,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () =>
//             FlutterBlue.instance.startScan(timeout: Duration(seconds: 60)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Visibility(
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     RaisedButton(
//                       onPressed: () {
//                         onCheckinClick("IN");
//                       },
//                       textColor: Colors.white,
//                       padding: const EdgeInsets.all(0.0),
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: <Color>[
//                               Color(0xFF0D47A1),
//                               Color(0xFF1976D2),
//                               Color(0xFF42A5F5),
//                             ],
//                           ),
//                         ),
//                         padding: const EdgeInsets.all(10.0),
//                         child: const Text('CHECK IN',
//                             style: TextStyle(fontSize: 20)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               visible: _isVisibleCheckin,
//             ),
//             Visibility(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Center(child: Text("Finding device in ")),
//                       CountdownTimer(
//                         controller: controller,
//                         onEnd: onEnd,
//                         endTime: endTime,
//                         widgetBuilder: (_, CurrentRemainingTime time) {
//                           if (time == null) {
//                             return Text("Overtime");
//                           }
//                           return Text(
//                               // 'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
//                               ' ${time.sec} s');
//                         },
//                       ),
//                     ],
//                   ),
//                   CircularProgressIndicator(),
//                 ],
//               ),
//               visible: _isVisibleLoading,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
