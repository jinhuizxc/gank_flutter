import 'package:flutter/material.dart';
import 'package:gank_flutter/models/DailyInfo.dart';
import 'package:gank_flutter/models/GankInfo.dart';
import 'package:gank_flutter/models/QQMusic.dart';
import 'package:gank_flutter/net/GankApi.dart';
import 'package:gank_flutter/net/QQMusicApi.dart';
import 'package:gank_flutter/widget/gankBanner.dart';

import '../colors.dart';
import 'CommonComponent.dart';
import 'HistoryListPage.dart';
import 'WebPage.dart';

/*class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
    );
  }
}*/

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeState();
  }
}

/*
 * AutomaticKeepAliveClientMixin:
 *
 */
class HomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  bool isLoading;

  // 定义实体类
  DailyInfo _dailyInfo;
  BuildContext contexts;
  List<Sliders> qqMusic = [];
  double width = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 开始拉取数据
    _pullNet();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    contexts = context;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("最新"),
        actions: <Widget>[
          // 右侧导航按钮，用于点击显示干货历史;
          IconButton(
              icon: const Icon(Icons.reorder),
              onPressed: () {
                setState(() {
                  Navigator.push(contexts == null ? context : contexts,
                      new MaterialPageRoute(builder: (context) {
                    return new HistoryListPage();
                  }));
                });
              })
        ],
      ),
      // 设置主页数据
//      body: LoadingWidget(),   // 加载视图没有问题;
      body: _dailyInfo == null
          ? LoadingWidget()
          : ListView(children: _showAllList()),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _pullNet() async {
    // 获取今天资讯
    await GankApi.getToday().then((DailyInfo info) {
      _dailyInfo = info;
      print("获取到的今日资讯 $_dailyInfo");
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });

    // 获取首页banner信息
    QQMusicApi.getQQBanner().then((QQMusic info) {
      setState(() {
        isLoading = false;
        qqMusic = info.data.slider;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  // 主页显示的列表数据
  List<Widget> _showAllList() {
    var list = List<Widget>();
    list.add(_top());  // qq音乐banner
    _dailyInfo.category.remove("福利");
    _dailyInfo.category.forEach((item) {
      list.addAll(_addCategory(GankInfo.fromJson(
          _dailyInfo.results[item][_dailyInfo.results[item].length - 1])));
    });
    return list;
  }

  Widget _top() {
    return Column(
      key: Key('__header__'),
      children: _pageSelector(context),
    );
  }

  List<Widget> _pageSelector(BuildContext context) {
    List<Widget> list = [];
    List<Sliders> bannerStories = [];
    qqMusic.forEach((item) {
      bannerStories.add(item);
    });
    if (qqMusic.length > 0) {
      list.add(GankBanner(bannerStories, (slider) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new WebPage(url: slider.linkUrl, title: "qq音乐");
        }));
      }));
    }
    return list;
  }

  List<Widget> _addCategory(GankInfo info) {
    var l = List<Widget>();
    l.add(HomeListWidget(info: info, contexts: contexts));
    if (info.type != _dailyInfo.category[_dailyInfo.category.length - 1])
      l.add(Divider(height: 0.5, color: c9));
    return l;
  }
}
