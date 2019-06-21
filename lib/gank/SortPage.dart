import 'package:flutter/material.dart';
import 'package:gank_flutter/gank/ArticleListPage.dart';
import 'package:gank_flutter/gank/FabuPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 干货
//class SortPage extends StatelessWidget{
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("SortPage"),
//      ),
//    );
//  }
//}

class SortPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SortPageState();
}

class _SortPageState extends State<SortPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // 设置TabController
  TabController _tabController;
  List<String> _allPages = <String>[
    '全部',
    'Android',
    'iOS',
    '前端',
    '休息视频',
    '拓展资源',
    '瞎推荐',
    'App'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _allPages.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("分类"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context) {
//                return new FabuPage();
//              }));
              Fluttertoast.showToast(
                  msg: "发布干货",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.blue);
            },
          )
        ],
        bottom: TabBar(
          tabs: _allPages.map<Tab>((String page) => Tab(text: page)).toList(),
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: _allPages.map<Widget>((String page) {
            if (page == '全部') return ArticleListPage(type: 'all');
            return ArticleListPage(type: page);
          }).toList()),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
