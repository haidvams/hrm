import 'package:flutter/material.dart';
import 'package:hrm/main/data/rest_data.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/theme1/screen/blog/BlogDetailsScreen.dart';
import 'package:hrm/theme1/screen/blog/BlogModel.dart';

class T1Blog extends StatefulWidget {
  @override
  _SdViewAllblogsScreenState createState() => _SdViewAllblogsScreenState();
}

class _SdViewAllblogsScreenState extends State<T1Blog>
    with SingleTickerProviderStateMixin {
  RestDatasource api = new RestDatasource();

  List<BlogsModel> blogs = [];

  getProject() async {
    Iterable data = await api.getDataPublic(
        '/api/resource/Blog%20Post?filters=[["Blog Post","published","=",1]]&fields=["*"]&limit_page_length=0');
    setState(() {
      blogs = data.map((item) => BlogsModel.fromJson(item)).toList();
    });
  }

  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  void initState() {
    super.initState();
    getProject();
    tabs = [
      'All blog'
      // 'general',
      // 'New Uploaded'
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mList(BlogsModel mblogs) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailsScreen(
                title: mblogs.title,
                blog_category: mblogs.blog_category,
                meta_image:mblogs.meta_image,
                blogger:mblogs.blogger,
                content:mblogs.content,
                comments:mblogs.comments,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
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
                    image: NetworkImage(mblogs.meta_image),
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
                        Expanded(child: Text(
                          mblogs.title,
                          style: boldTextStyle(size: 16),
                        ),),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 6),
                        //   child: Align(
                        //     alignment: Alignment.topRight,
                        //     child: Icon(Icons.more_vert),
                        //   ),
                        // )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        mblogs.blog_intro,
                        style: primaryTextStyle(
                          size: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FittedBox(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        decoration: boxDecorations(
                            bgColor: sdSecondaryColorRed, radius: 4),
                        padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                        child: Center(
                          child: Text(
                            mblogs.blog_category,
                            style: secondaryTextStyle(
                              size: 8,
                              textColor: Colors.white,
                            ),
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
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: sdPrimaryColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Container(
              color: sdPrimaryColor,
              height: MediaQuery.of(context).size.width * 0.5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16, left: 16),
                  child: Text(
                    'Ams blogs',
                    style: boldTextStyle(textColor: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    indicatorWeight: 4.0,
                    labelColor: Colors.white,
                    labelStyle: boldTextStyle(size: 14),
                    unselectedLabelColor: Colors.white.withOpacity(.5),
                    controller: _tabController,
                    tabs: tabs.map((e) => Tab(text: e)).toList(),
                  ),
                ),
                if (_currentIndex == 0)
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: blogs.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return mList(blogs[index]);
                      }),
                if (_currentIndex == 1)
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: blogs.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return mList(blogs[index]);
                      }),
                if (_currentIndex == 2)
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: blogs.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return mList(blogs[index]);
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

