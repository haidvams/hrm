import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';

class ChatPageDetail extends StatefulWidget {
  String name;
  String profileImages;

  ChatPageDetail({this.name, this.profileImages});

  @override
  _SDChatPageViewScreenState createState() => _SDChatPageViewScreenState();
}

class _SDChatPageViewScreenState extends State<ChatPageDetail> {
  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  String _username;
  var childList = <Widget>[];

  List<AChatsDetailModel> listChats = [];
  getHistoryChat() async {
    User user = await db.getUser();
    Iterable data = await api.getFormData(
        '/api/method/frappe.chat.doctype.chat_room.chat_room.history',
        user.sid, {"user": user.username, "room": widget.name});
print(data);
    // setState(() {
    //   _username = user.username;
    //   listChats = data.map((item) => AChatsDetailModel.fromJson(item)).toList();
    //   print(listChats);
    // });
  }

  @override
  void initState() {
    super.initState();
    getHistoryChat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 65,
                    color: sdPrimaryColor,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage(
                                'Loading',
                              ),
                              image: Image.network(
                                widget.profileImages == null
                                    ? 'https://i.insider.com/5de6dd81fd9db241b00c04d3?width=1100&format=jpeg&auto=webp'
                                    : widget.profileImages,
                                height: 35,
                                width: 10,
                              ).image,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.name == null
                                    ? 'Ankit Gada'
                                    : widget.name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Text(
                                  "online",
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.only(right: 5),
                          child: PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text("View Contact"),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Text("Search"),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      child: Text("Mute notification"),
                                    ),
                                    PopupMenuItem(
                                      value: 4,
                                      child: Text("Report"),
                                    ),
                                    PopupMenuItem(
                                      value: 5,
                                      child: Text("Clear chat"),
                                    ),
                                    PopupMenuItem(
                                      value: 6,
                                      child: Text("Block user"),
                                    ),
                                  ]),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    // height: 500,
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        // reverse: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView.builder(
                                itemCount:
                                    listChats == null ? 0 : listChats.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                    if (listChats[index].user == _username)
                                   return Align(
                                        alignment: Alignment(1, 0),
                                        child: SendedMessageWidget(
                                          content: listChats[index].content,
                                          time: listChats[index].creation,
                                        ),
                                      );
                                    else
                                  return Align(
                                        alignment: Alignment(-1, 0),
                                        child: ReceivedMessageWidget(
                                          content: listChats[index].content,
                                          time: listChats[index].creation,
                                        ),
                                      );
                                })
                          ],
                        )),
                  ),
                  Divider(height: 0, color: Colors.black26),
                  Container(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                      height: 75,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 5),
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 15, right: 5),
                              decoration: boxDecoration(
                                  radius: 5,
                                  backGroundColor: Colors.white60,
                                  blurRadius: 0,
                                  spreadRadius: 0),
                              child: TextField(
                                style: TextStyle(fontSize: 20),
                                controller: _text,
                                maxLines: 15,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type your message',
                                  hintStyle: secondaryTextStyle(),
                                  suffixIcon: Icon(Icons.attach_file),
                                  prefixIcon: Icon(Icons.insert_emoticon),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, bottom: 15),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: sdPrimaryColor,
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 TextField(
                        maxLines: 20,
                        controller: _text,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                          suffixIcon: CircleAvatar(
                            radius: 20,
                            backgroundColor: sdPrimaryColor,
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.insert_emoticon),
                            onPressed: () {},
                          ),
                          border: InputBorder.none,
                          hintText: "Type your message",
                        ),
                      ),
* */
/*CircleAvatar(
radius: 20,
backgroundColor: sdPrimaryColor,
child: IconButton(
icon: Icon(
Icons.send,
color: Colors.white,
size: 20,
),
onPressed: () {},
),
)*/
Widget ReceivedMessageWidget({String content, String time}) {
  return Container(
      child: Padding(
    padding:
        const EdgeInsets.only(right: 75.0, left: 8.0, top: 8.0, bottom: 8.0),
    child: Container(
      decoration: boxDecorations(showShadow: true, radius: 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
              child: Text(
                content,
                style: primaryTextStyle(
                  size: 14,
                  textColor: Colors.black,
                ),
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    ),
  ));
}

Widget SendedMessageWidget({String content, String time}) {
  return Container(
    child: Padding(
      padding:
          const EdgeInsets.only(right: 8.0, left: 50.0, top: 4.0, bottom: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5)),
        child: Container(
          color: sdPrimaryColor,
          // margin: const EdgeInsets.only(left: 10.0),
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  right: 12.0, left: 12.0, top: 8.0, bottom: 16.0),
              child: Text(
                content,
                style: primaryTextStyle(size: 14, textColor: Colors.white),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 10,
              child: Text(
                time,
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withOpacity(0.8)),
              ),
            )
          ]),
        ),
      ),
    ),
  );
}

class AChatsDetailModel {
  String name;
  String room;
  String room_type;
  String content;
  String user;
  String creation;

  AChatsDetailModel({
    this.name,
    this.room,
    this.room_type,
    this.content,
    this.user,
    this.creation,
  });

  factory AChatsDetailModel.fromJson(Map<String, dynamic> json) {
    return AChatsDetailModel(
      name: json['name'] ??= null,
      room: json["room"] ??= null,
      room_type: json['room_type'] ??= null,
      content: json['content'] ??= null,
      user: json['user'] ??= null,
      creation:
          DateFormat('Hm').format(DateTime.parse(json["creation"])).toString(),
    );
  }
}
