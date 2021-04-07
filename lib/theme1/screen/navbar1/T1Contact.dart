import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/theme1/model/T1_model.dart';
import 'package:hrm/theme1/utils/T1Colors.dart';
import 'package:hrm/theme1/utils/T1Constant.dart';
import 'package:hrm/theme1/utils/T1DataGenerator.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:hrm/theme1/utils/T1Strings.dart';
import 'package:hrm/theme1/utils/T1Widget.dart';
import 'package:url_launcher/url_launcher.dart';

class T1Contact extends StatefulWidget {
  static var tag = "/T1Contact";


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return T1ContactState();
  }
}

class T1ContactState extends State<T1Contact> {
  List<T1Model> mListings;
  List<T1ModelContact> _contacts = List<T1ModelContact>();
  bool _visibleIndi = true;


  RestDatasource api = new RestDatasource();

  Future getContact() async {
    Iterable data = await api.getDataPublic(
        '/api/resource/Employee/?fields=["employee_name","name","emergency_phone_number","department","avarta"]');
    setState(() {
      _contacts =
          data.map((model) => T1ModelContact.fromJson(model)).toList();
      _visibleIndi = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getContact();
    // mListings = getListings();
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: boxDecoration(radius: 10, showShadow: true),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: _contacts[index].avarta,
                            width: width / 5.5,
                            height: width / 6,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: text(
                                          _contacts[index].employee_name,
                                          textColor: t1TextColorPrimary,
                                          fontFamily: fontBold,
                                          fontSize: 20.0,
                                          maxLine: 1),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                        size: 40.0,
                                      ),
                                      // onPressed: () {
                                      //   print("tel:"+_contacts[index].emergency_phone_number);
                                      // },
                                      onPressed: () => launch("tel:" +
                                          _contacts[index]
                                              .emergency_phone_number),
                                    )
                                  ],
                                ),
                                text(_contacts[index].department,
                                    fontSize: 16.0,
                                    textColor: t1TextColorPrimary,
                                    fontFamily: fontMedium),
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 35,
                margin: EdgeInsets.only(top: 16),
                color: t1_colorPrimary,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 50, left: 16, bottom: 16),
                width: width,
                color: Color(0xFF3281FF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Danh bạ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 0.5),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Liên hệ nhanh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    )
                  ],
                )),

            Visibility(
                visible: _visibleIndi,
                child: CircularProgressIndicator(),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _contacts.length,
                  shrinkWrap: true,
                  itemBuilder: _buildItemsForListView),
            )
          ],
        ),
      ),
    );
  }
}

class T1ModelContact {
  String name;
  String employee_name;
  String emergency_phone_number;
  String department;
  String avarta;

  T1ModelContact(
      {this.name,
      this.employee_name,
      this.emergency_phone_number,
      this.department,
      this.avarta});

  factory T1ModelContact.fromJson(Map<String, dynamic> json) {
    return T1ModelContact(
      name: json['name'] ??= null,
      employee_name: json['employee_name'] ??= null,
      emergency_phone_number: json['emergency_phone_number'] ??= "0918876874",
      department: json['department'] ??= null,
      avarta: json['avarta'] == null
          ? RestDatasource.BASE_URL + "/files/icons8-user.png"
          : RestDatasource.BASE_URL + json['avarta'],
    );
  }
}
