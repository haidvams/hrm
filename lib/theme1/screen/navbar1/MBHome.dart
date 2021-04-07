import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/AppConstant.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/T1AllHr.dart';
import 'package:hrm/theme1/screen/blog/BlogDetailsScreen.dart';
import 'package:hrm/theme1/screen/blog/BlogModel.dart';
import 'package:hrm/theme1/screen/blog/T1Blog.dart';
import 'package:hrm/theme1/screen/projects/T1AllProject.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';

class DashBoardHome extends StatefulWidget {
  @override
  _DashBoardHomeState createState() => _DashBoardHomeState();
}

class _DashBoardHomeState extends State<DashBoardHome> {
  var width;
  var height;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

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

  _onCheckoutClick() async {
    String _deviceId = await _getId();
    Map dataBody = await {"log_type": "OUT", "device_id": _deviceId};
    User user = await db.getUser();

    try {
      var res = await api.postPrivateAll(
          '/api/resource/Employee%20Checkin', user.sid, dataBody);
      if (res == true) {
        await LoadingDialog.hide(context);
        _showSnackBar("Checkout thành công, Hệ thống đang ghi điểm danh...");
        await Future<void>.delayed(Duration(milliseconds: 2000));

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => T1Checkin()));
      } else {
        await LoadingDialog.hide(context);
        await Future<void>.delayed(Duration(milliseconds: 500));
        _showSnackBar("Chưa ghi được checkout, Thử lại hoặc báo với bộ phận HR");
      }
    } catch (e) {
      print(e);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 20),
              physics: ScrollPhysics(),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: text('Blog',
                                textColor: t1TextColorPrimary,
                                fontSize: textSizeNormal,
                                fontFamily: fontBold),
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
                              style: boldTextStyle(
                                  textColor: sdPrimaryColor, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 15),
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: Slider(),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: text('Hrm',
                                      textColor: t1TextColorPrimary,
                                      fontSize: textSizeNormal,
                                      fontFamily: fontBold),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => T1AllHr(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'SEE ALL',
                                    style: boldTextStyle(
                                        textColor: sdPrimaryColor, size: 12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10.0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  mediaButton(
                                      "Checkin",
                                      'images/theme1/icons8-ibeacon.png',
                                      "/BeaconScanner"),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          CheckoutDialog(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: t1_color_primary_light),
                                          width: width / 5.5,
                                          height: width / 5.5,
                                          padding: EdgeInsets.all(width / 18),
                                          // child: SvgPicture.asset(
                                          //   icon,
                                          //   color: t1_colorPrimary,
                                          // ),
                                          child: Image.asset(
                                              "images/theme1/icons8-sign_out.png"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      text("Checkout",
                                          textColor: t1TextColorPrimary,
                                          fontSize: textSizeMedium,
                                          fontFamily: fontMedium)
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  mediaButton(
                                      "Leave",
                                      'images/theme1/icons8-leave.png',
                                      "/T1LeaveApplication"),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: text('Projects',
                                      textColor: t1TextColorPrimary,
                                      fontSize: textSizeNormal,
                                      fontFamily: fontBold),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => T1AllProject(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'SEE ALL',
                                    style: boldTextStyle(
                                        textColor: sdPrimaryColor, size: 12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, left: 10.0, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  mediaButton(
                                      "Project",
                                      "images/theme1/icons8-project-48.png",
                                      "/T1Project"),
                                  mediaButton(
                                      "Task",
                                      "images/theme1/icons8-task.png",
                                      "/T1Task"),
                                  mediaButton(
                                      "Task confirm",
                                      'images/theme1/icons8-ticket_confirmed.png',
                                      "/ComfirmTask"),
                                ],
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: height * 0.1,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget mediaButton(String buttonText, String icon, String broute) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, broute);
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: t1_color_primary_light),
            width: width / 5.5,
            height: width / 5.5,
            padding: EdgeInsets.all(width / 18),
            // child: SvgPicture.asset(
            //   icon,
            //   color: t1_colorPrimary,
            // ),
            child: Image.asset(icon),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        text(buttonText,
            textColor: t1TextColorPrimary,
            fontSize: textSizeMedium,
            fontFamily: fontMedium)
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  CheckoutDialog(BuildContext context) {
    // set up the buttons
    Widget checkoutButton = FlatButton(
      child: Text("Checkout"),
      onPressed: () async {
        Navigator.pop(context);
        await Future<void>.delayed(Duration(milliseconds: 500));
        LoadingDialog.show(context);
        _onCheckoutClick();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
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
}

class Slider extends StatefulWidget {
  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  List<BlogsModel> blogs = [];

  getBlogs() async {
    Iterable data = await api.getDataPublic(
        '/api/resource/Blog%20Post?filters=[["Blog Post","published","=",1]]&fields=["*"]&limit_page_length=3');
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
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: blogs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailsScreen(
                    title: blogs[index].title,
                    blog_category: blogs[index].blog_category,
                    meta_image: blogs[index].meta_image,
                    blogger: blogs[index].blogger,
                    content: blogs[index].content,
                    comments: blogs[index].comments,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              blogs[index].meta_image),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            blogs[index].title,
                            style: boldTextStyle(size: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          child: FittedBox(
                            child: Html(
                              data: blogs[index].blog_intro.substring(0, 50) +
                                  '...',
                              style: {
                                'div': Style(
                                  fontSize: FontSize(14),
                                  color: Colors.grey,
                                )
                              },
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Container(
                            margin: EdgeInsets.only(left: 8, top: 2),
                            decoration: boxDecorations(
                                bgColor: sdSecondaryColorRed, radius: 4),
                            padding: EdgeInsets.all(5),
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
