import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hrm/main/utils/SDStyle.dart';

class BlogDetailsScreen extends StatefulWidget {
  String title;
  String blog_category;
  String meta_image;
  String blogger;
  String content;
  String comments;

  BlogDetailsScreen(
      {this.title,
      this.blog_category,
      this.meta_image,
      this.blogger,
      this.comments,
      this.content});

  @override
  _SDLessonsDetScreenState createState() => _SDLessonsDetScreenState();
}

class _SDLessonsDetScreenState extends State<BlogDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List _comment = (widget.comments==null ? [] :jsonDecode(widget.comments));
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    height: 270,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: widget.meta_image == null
                              ? AssetImage(
                                  "images/widgets/materialWidgets/mwInformationDisplayWidgets/cards/widget_card1.jpg")
                              : NetworkImage(widget.meta_image),
                          fit: BoxFit.cover),
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          width: size.width,
                          color: Colors.grey.withOpacity(0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black12,
                                child: CloseButton(),
                              ),
                              Expanded(
                                child: Container(
                                  width: size.width * 0.55,
                                  margin: EdgeInsets.only(top: 70),
                                  child: Text(
                                    widget.title == null
                                        ? 'Title'
                                        : widget.title,
                                    style:
                                        boldTextStyle(textColor: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.blog_category == null
                                      ? 'blog ams'
                                      : widget.blog_category,
                                  style: secondaryTextStyle(
                                      textColor: Colors.white.withOpacity(0.8)),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: AssetImage(
                                                'images/theme1/icons8-user-48.png'),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            top: 25,
                                            child: CircleAvatar(
                                              radius: 5,
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.green,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 0),
                                            child: Text(
                                              widget.blogger,
                                              style: boldTextStyle(
                                                  size: 16,
                                                  textColor: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              'Poster',
                                              style: secondaryTextStyle(
                                                  size: 10,
                                                  textColor: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 150,
                    bottom: -40,
                    child: Container(
                      height: 170,
                      width: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: widget.meta_image == null
                                ? AssetImage(
                                    "images/widgets/materialWidgets/mwInformationDisplayWidgets/cards/widget_card1.jpg")
                                : NetworkImage(widget.meta_image),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 35, left: 15, right: 15),
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Html(
                        data: widget.content,
                        style: {
                          'div': Style(
                            fontSize: FontSize(14),
                            color: Color(0xFF757575),
                          )
                        },
                      ),
                    ),
                    //comment
                    Text(
                      "List Comment",
                      style: boldTextStyle(size: 16),
                    ),
                    ListView.builder(
                      itemCount: _comment == null ? 0 : _comment.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         SDLessonsDetailsScreen(),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _comment[index]["by"],
                                        style: boldTextStyle(size: 14),
                                      ),
                                      Container(
                                        child: Html(
                                          data: _comment[index]["comment"],
                                          style: {
                                            'div': Style(
                                              fontSize: FontSize(12),
                                              color: Color(0xFF757575),
                                            )
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
