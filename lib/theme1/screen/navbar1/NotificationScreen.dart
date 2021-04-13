import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/smartDeck/ModelClass/SDNotidicationModel.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List _notifis = [];
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  RestDatasource api = new RestDatasource();

  getNotifis() async {
    var notifis = await api.getDataBySid(
        '/api/method/frappe.model.db_query.get_list?fields=["name","subject","subject","for_user","type","email_content","document_type","document_name","from_user","creation","read"]&limit=20&order_by=creation desc&doctype=Notification Log');
    if(notifis.isNotEmpty && !notifis.containsKey('error')){
      setState(() {
        _notifis = notifis["message"];
      });
    }else{
      print("cos loi roi");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifis();
  }

  @override
  Widget build(BuildContext context) {
    Widget mPopup() => PopupMenuButton(
          itemBuilder: (context) {
            var list = List<PopupMenuEntry<Object>>();
            list.add(
              PopupMenuItem(
                child: Text("Mark as read"),
                value: 1,
              ),
            );
            list.add(
              PopupMenuItem(
                child: Text("Mute Notification"),
                value: 1,
              ),
            );
            list.add(
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    //  launchScreen(context, SocialVerify.tag);
                  },
                  child: Text("Settings"),
                ),
                value: 1,
              ),
            );
            return list;
          },
          child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.more_vert,
                color: sdTextPrimaryColor,
              )),
        );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: InkWell(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          // ),
          title: Text('Thông báo', style: boldTextStyle(size: 20)),
          actions: <Widget>[mPopup()],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
            itemCount: _notifis == null ? 0 : _notifis.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(left: 4),
                child: ListTile(
                    // leading: Container(
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //   ),
                    //   height: 40,
                    //   width: 40,
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(40),
                    //     child: FadeInImage(
                    //       fit: BoxFit.cover,
                    //       placeholder: Image.asset(_notifis[index]["type"],
                    //               height: 35, width: 10)
                    //           .image,
                    //       // image: Image.network(
                    //       //   notification[index].images,
                    //       //   height: 35,
                    //       //   width: 10,
                    //       // ).image,
                    //     ),
                    //   ),
                    // ),
                    title: Text(
                      _notifis[index]["subject"],
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        _notifis[index]["creation"],
                        style: secondaryTextStyle(),
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: _notifis[index]["read"] == 0 ? 4 : 0,
                        backgroundColor: Colors.red,
                      ),
                    )),
              );
            }),
      ),
    );
  }
}

class ModelNotificaton {
  String name;
  String subject;
  String for_user;
  String type;
  String email_content;
  String document_type;
  String document_name;
  String from_user;
  String creation;
  int read;

  ModelNotificaton(
      {this.name,
      this.subject,
      this.for_user,
      this.type,
      this.email_content,
      this.document_name,
      this.document_type,
      this.read,
      this.creation,
      from_user});
}
