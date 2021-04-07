
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/smartDeck/ModelClass/SDExamCardModel.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDAllLessonsScreen.dart';
import 'package:hrm/smartDeck/Screens/SDExamScreen.dart';
import 'package:hrm/smartDeck/Screens/SDLessonsChapterDetailsScreen.dart';
import 'package:hrm/smartDeck/Screens/SDNotificationScreen.dart';
import 'package:hrm/smartDeck/Screens/SDSearchScreen.dart';
import 'package:hrm/theme1/screen/attendance/Checkout.dart';
import 'package:hrm/theme1/screen/attendance/T1Checkin.dart';
import 'package:hrm/theme1/screen/blog/BlogDetailsScreen.dart';
import 'package:hrm/theme1/screen/blog/BlogModel.dart';
import 'package:hrm/theme1/screen/blog/T1Blog.dart';
import 'package:hrm/theme1/screen/attendance/BlueCheckin.dart';
import 'package:hrm/theme1/screen/leaves/T1LeaveApplication.dart';
import 'package:hrm/theme1/screen/tasks/ComfirmTask.dart';
import 'package:hrm/theme1/screen/tasks/PostTask.dart';

List<erpModel> hrm = [
  // erpModel(
  //     image: 'images/theme1/icons8-eye_checked.png',
  //     title: 'Checkin',
  //     widgetAction: BlueCheckin()),
  erpModel(
    image: 'images/theme1/icons8-sign_out.png',
    title: 'Checkout',
    widgetAction: true),
  erpModel(
    image: 'images/theme1/icons8-leave.png',
    title: 'Leave',
    widgetAction: T1LeaveApplication()),
  // erpModel(
  //   image: 'images/theme1/icons8-task.png',
  //   title: 'New Task',
  //   widgetAction: PostTask()),
  erpModel(
    image: 'images/theme1/icons8-ticket_confirmed.png',
    title: 'Task confirming',
    widgetAction: ComfirmTask()),
  // erpModel(
  //   image: 'images/theme1/icons8-event_accepted_tentatively.png',
  //   title: 'Task approval',
  //   widgetAction: PostTask()),
];





List<SDExamCardModel> cards = [
  SDExamCardModel(
    image: 'images/smartDeck/images/sdbiology.png',
    examName: 'Biology final\nexams',
    time: '15 minutes',
    icon: Icon(
      Icons.notifications_active,
      color: Colors.white54,
    ),
    startColor: Color(0xFF2889EB),
    endColor: Color(0xFF0B56CB),
  ),
  SDExamCardModel(
    image: 'images/smartDeck/images/sdchemistry.png',
    examName: 'Chemistry daily\ntest',
    time: '15 minutes',
    icon: Icon(
      Icons.notifications_off,
      color: Colors.white54,
    ),
    startColor: Color(0xFFF1AD4B),
    endColor: Color(0xFFF26340),
  ),
  SDExamCardModel(
    image: 'images/smartDeck/images/sdmusic.png',
    examName: 'Music daily\nlearning',
    time: '3 hours',
    icon: Icon(
      Icons.notifications,
      color: Colors.white54,
    ),
    startColor: Color(0xFF7EA56C),
    endColor: Color(0xFF6C9258),
  )
];

Widget SDDashboard(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();

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


  _onCheckoutClick(String type) async {
    String _deviceId = await _getId();
    Map dataBody = await {"log_type": type, "device_id": _deviceId};

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

  CheckoutDialog(BuildContext context) {
    // set up the buttons
    Widget checkoutButton = FlatButton(
      child: Text("Checkout"),
      onPressed:  () {
        _onCheckoutClick("OUT");
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Comfirm"),
      content: Text("Do you agree to checkout?"),
      actions: [
        cancelButton,
        checkoutButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  return Container(
    child: SingleChildScrollView(
      padding: EdgeInsets.only(top: 20, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: boxDecoration(
                        radius: 5,
                        backGroundColor: sdViewColor.withOpacity(0.8),
                        blurRadius: 0,
                        spreadRadius: 0),
                    child: TextField(
                      autofocus: false,
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SDSearchScreen(),
                          ),
                        );
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.only(left: 10, top: 5, right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SDNotificationScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.notifications_none,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 9,
                      top: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '3',
                          style: secondaryTextStyle(textColor: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 16, right: 16),
          //   child: Text(
          //     'Hi, Haidv',
          //     style: boldTextStyle(size: 20),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   margin: EdgeInsets.only(left: 16, right: 16),
          //   child: Text(
          //     'You have 3 survey',
          //     style: secondaryTextStyle(size: 14),
          //   ),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 250,
          //   child: ListView.builder(
          //       padding: EdgeInsets.only(right: 16),
          //       scrollDirection: Axis.horizontal,
          //       itemCount: cards == null ? 0 : cards.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => SDExamScreen(
          //                     cards[index].examName,
          //                     cards[index].image,
          //                     cards[index].startColor,
          //                     cards[index].endColor),
          //               ),
          //             );
          //           },
          //           child: Container(
          //             width: 180.0,
          //             margin: EdgeInsets.only(
          //               left: 16,
          //             ),
          //             padding: EdgeInsets.all(10),
          //             decoration: boxDecoration(
          //               radius: 8,
          //               spreadRadius: 1,
          //               blurRadius: 4,
          //               gradient: LinearGradient(
          //                 colors: [
          //                   cards[index].startColor,
          //                   cards[index].endColor
          //                 ],
          //               ),
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: <Widget>[
          //                 CircleAvatar(
          //                   radius: 40,
          //                   backgroundColor: Colors.white30,
          //                   child: Image.asset(
          //                     cards[index].image,
          //                     height: 60,
          //                     width: 60,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 15,
          //                 ),
          //                 Text(
          //                   cards[index].examName,
          //                   style: secondaryTextStyle(
          //                       textColor: Colors.white, size: 20),
          //                 ),
          //                 SizedBox(
          //                   height: 15,
          //                 ),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: <Widget>[
          //                     Text(
          //                       cards[index].time,
          //                       style: secondaryTextStyle(
          //                           textColor: Colors.white54, size: 18),
          //                     ),
          //                     cards[index].icon
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //         );
          //       }),
          // ),
          // SizedBox(
          //   height: 25,
          // ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Utilities',
                    style: boldTextStyle(size: 16),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => SDLessons(),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     'SEE ALL',
                //     style: boldTextStyle(textColor: sdPrimaryColor, size: 14),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              'quick action',
              style: secondaryTextStyle(size: 14),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 150,
            child: ListView.builder(
                padding: EdgeInsets.only(right: 16),
                scrollDirection: Axis.horizontal,
                itemCount: hrm.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if(hrm[index].widgetAction is bool){
                        CheckoutDialog(context);

                      }else{

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => hrm[index].widgetAction,
                          ),
                        );
                      }

                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              hrm[index].image,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(hrm[index].title),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'AMS Blog',
                    style: boldTextStyle(size: 16),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => T1Blog(),
                      ),
                    );
                  },
                  child: Text(
                    'SEE ALL',
                    style: boldTextStyle(textColor: sdPrimaryColor, size: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlogWidget(),
        ],
      ),
    ),
  );
}


class BlogWidget extends StatefulWidget {
  @override
  _BlogWidgetState createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  List<BlogsModel> blogs = [];

  getBlogs() async {
    Iterable data = await api.getDataPublic(
        '/api/resource/Blog%20Post?filters=[["Blog Post","published","=",1]]&fields=["*"]&limit_page_length=0');
    setState(() {
      blogs = data.map((item) => BlogsModel.fromJson(item)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: ListView.builder(
        padding: EdgeInsets.only(right: 16),
        scrollDirection: Axis.horizontal,
        itemCount: blogs.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetailsScreen(
                      title: blogs[index].title,
                      blog_category: blogs[index].blog_category,
                      meta_image:blogs[index].meta_image,
                      blogger:blogs[index].blogger,
                      content:blogs[index].content,
                      comments:blogs[index].comments,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 20),
                width: 300,
                decoration: boxDecorations(
                  showShadow: true,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 115,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(blogs[index].meta_image),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  blogs[index].title,
                                  style: boldTextStyle(size: 16),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 6),
                              //   child: Align(
                              //     alignment: Alignment.topRight,
                              //     child: Icon(Icons.more_vert),
                              //   ),
                              // )
                            ],
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 8),
                          //   child: FittedBox(
                          //     child: Html(
                          //       data: blogs[index].blog_intro.substring(0,90) + '...',
                          //       style: {
                          //         'div': Style(
                          //           fontSize: FontSize(14),
                          //           color: Colors.grey,
                          //         )
                          //       },
                          //     ),
                          //   ),
                          // ),
                          FittedBox(
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              decoration: boxDecorations(
                                  bgColor: sdSecondaryColorRed, radius: 4),
                              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                              child: Center(
                                child: Text(
                                  blogs[index].blog_category,
                                  style: secondaryTextStyle(
                                      size: 14, textColor: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}

class erpModel {
  String image;
  String title;
  final widgetAction;

  erpModel({
    this.image,
    this.title,
    this.widgetAction,
  });
}


