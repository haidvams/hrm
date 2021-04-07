import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDChatPageViewScreen.dart';
import 'package:hrm/smartDeck/Screens/SDSortScreen.dart';
import 'package:hrm/theme1/screen/chatroom/ChatModel.dart';
import 'package:hrm/theme1/screen/chatroom/ChatPageDetail.dart';
import 'package:hrm/theme1/screen/chatroom/CreatChatRoom.dart';

class ChatScreenMain extends StatefulWidget {
  @override
  _SDChatScreenState createState() => _SDChatScreenState();
}

class _SDChatScreenState extends State<ChatScreenMain>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;
  RestDatasource api = new RestDatasource();
  var db = new DatabaseHelper();
  String avatar_local = "images/theme1/icons8-user-48.png";
  List<AChatsModel> personalChats = [];

  List<AChatsModel> groupChats = [];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getListRoomChat() async {
    User user = await db.getUser();
    Iterable data = await api.getFormData(
        '/api/method/frappe.chat.doctype.chat_room.chat_room.get',
        user.sid,
        {"user": user.username});
    setState(() {
      personalChats = data
          .where((element) => element["type"] == "Direct")
          .map((item) => AChatsModel.fromJson(item))
          .toList();
      groupChats = data
          .where((element) => element["type"] == "Group")
          .map((item) => AChatsModel.fromJson(item))
          .toList();
    });
  }

  void initState() {
    super.initState();
    getListRoomChat();
    tabs = ['Personal', 'Group'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15, left: 25),
                height: 50,
                width: size.width,
                color: sdPrimaryColor,
                child: Text(
                  'Chatroom',
                  style: primaryTextStyle(textColor: Colors.white),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    color: sdPrimaryColor,
                    child: TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      indicatorWeight: 4.0,
                      labelStyle: boldTextStyle(size: 14),
                      unselectedLabelColor: Colors.white.withOpacity(.5),
                      controller: _tabController,
                      tabs: tabs.map((e) => Tab(text: e)).toList(),
                    ),
                  ),
                  if (_currentIndex == 0)
                    ListView.builder(
                        itemCount:
                            personalChats == null ? 0 : personalChats.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(avatar_local),
                                  ),
                                  title: Text(
                                    personalChats[index]
                                        .employee_name
                                        .toString(),
                                    style: boldTextStyle(
                                        size: 16,
                                        textColor:
                                            Colors.black.withOpacity(0.8)),
                                  ),
                                  subtitle: (personalChats[index]
                                              .last_message !=
                                          null)
                                      ? Text(
                                          personalChats[index]
                                              .last_message["content"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(size: 12),
                                        )
                                      : Text("Empty",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(size: 12)),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (personalChats[index].last_message !=
                                          null)
                                        Text(
                                          DateFormat('Hm').format(DateTime
                                              .parse(personalChats[index]
                                                  .last_message["creation"])),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      personalChats[index].last_message != null
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              height: 22,
                                              width: 22,
                                              decoration: BoxDecoration(
                                                  color: sdSecondaryColorRed,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(25.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  "1",
                                                  style: primaryTextStyle(
                                                      size: 11,
                                                      textColor: Colors.white),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPageDetail(
                                          name: personalChats[index].name,
                                          profileImages:
                                              personalChats[index].avatar,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        })
                  else if (_currentIndex == 1)
                    ListView.builder(
                        itemCount: groupChats == null ? 0 : groupChats.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                flex: 10,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        (groupChats[index].avatar == null)
                                            ? AssetImage(avatar_local)
                                            : NetworkImage(
                                                RestDatasource.BASE_URL +
                                                    groupChats[index].avatar),
                                  ),
                                  title: Text(
                                    groupChats[index].room_name,
                                    style: boldTextStyle(
                                        size: 16,
                                        textColor:
                                            Colors.black.withOpacity(0.8)),
                                  ),
                                  subtitle: (groupChats[index].last_message !=
                                          null)
                                      ? Text(
                                          groupChats[index]
                                              .last_message["content"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(size: 12),
                                        )
                                      : Text("Empty",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(size: 12)),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "16H 00",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      groupChats[index].last_message != null
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              height: 22,
                                              width: 22,
                                              decoration: BoxDecoration(
                                                  color: sdSecondaryColorRed,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(25.0),
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  groupChats[index]
                                                      .last_message["content"],
                                                  style: primaryTextStyle(
                                                      size: 11,
                                                      textColor: Colors.white),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SDChatPageViewScreen(
                                          name: groupChats[index].name,
                                          profileImages:
                                              groupChats[index].avatar,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        })
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: sdPrimaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatChatRoom(),
                ),
              );
            },
            label: Text(
              'Contacts',
              style: boldTextStyle(size: 16, textColor: Colors.white),
            ),
            icon: Icon(Icons.contacts)),
      ),
    );
  }
}
