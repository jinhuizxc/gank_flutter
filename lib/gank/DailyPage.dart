import 'package:flutter/material.dart';
import 'package:gank_flutter/colors.dart';
import 'package:gank_flutter/models/DailyInfo.dart';
import 'package:gank_flutter/models/GankInfo.dart';
import 'package:gank_flutter/net/GankApi.dart';
import 'CommonComponent.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 每日一页
class DailyPage extends StatefulWidget {
  final String title;

  DailyPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DailyPageState();
  }
}

class DailyPageState extends State<DailyPage> {
  bool isLoading;
  DailyInfo _dailyInfo;
  BuildContext contexts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pullNet();
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: _dailyInfo == null
          ? LoadingWidget()
          : ListView(children: _showAllList()),
    );
  }

  void _pullNet() {
    GankApi.getDailyInfo(widget.title.replaceAll("-", "/"))
        .then((DailyInfo info) {
      isLoading = false;
      setState(() {
        _dailyInfo = info;
      });
    });
  }

  List<Widget> _showAllList() {
    var list = List<Widget>();
    var top = new Container(
      child: new GestureDetector(
        onTap: () {
          showPhoto(contexts, GankInfo.fromJson(_dailyInfo.results["福利"][0]));
        },
        child: Hero(
            tag: GankInfo.fromJson(_dailyInfo.results["福利"][0]).desc,
            child: new CachedNetworkImage(
              imageUrl: _dailyInfo.results["福利"] == null ||
                      _dailyInfo.results["福利"].isEmpty
                  ? ""
                  : GankInfo.fromJson(_dailyInfo.results["福利"][0]).url,
              fit: BoxFit.cover,
              height: 190.0,
            )),
      ),
    );

    list.add(top);
    _dailyInfo.category.remove("福利");
    _dailyInfo.category.forEach((item) {
      list.addAll(_showList(GankInfo.fromJson(
          _dailyInfo.results[item][_dailyInfo.results[item].length - 1])));
    });
    return list;
  }

  List<Widget> _showList(GankInfo info) {
    var list = List<Widget>();
    list.add(HomeListWidget(info: info, contexts: contexts));
    if (info.type != _dailyInfo.category[_dailyInfo.category.length - 1])
      list.add(Divider(height: 0.5, color: c9));
    return list;
  }

  void showPhoto(BuildContext context, GankInfo gankInfo) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(gankInfo.desc),
          centerTitle: true,
        ),
        body: Center(
          child: Hero(
              tag: gankInfo.desc,
              child: new CachedNetworkImage(
                imageUrl: gankInfo.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => new Image(
                      image: AssetImage("images/fuli.png"),
                      fit: BoxFit.cover,
                    ),
              )),
        ),
      );
    }));
  }
}
