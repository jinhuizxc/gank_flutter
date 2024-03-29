import 'package:flutter/material.dart';
import 'package:gank_flutter/colors.dart';
import 'package:gank_flutter/gank/CommonComponent.dart';
import 'package:gank_flutter/gank/WebPage.dart';
import 'package:gank_flutter/models/BannerData.dart';
import 'package:gank_flutter/models/WanList.dart';
import 'package:gank_flutter/net/WanAndroidApi.dart';
import 'package:gank_flutter/widget/wan_banner.dart';

// wanandroid页面
class WanPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("WanPage"),
      ),
    );
  }
}

class WanPage extends StatefulWidget {
//  WanPage({Key key, this.type}) : super(key: key);
//
//  final String type;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WanPageState();
  }
}

class WanPageState extends State<WanPage> with AutomaticKeepAliveClientMixin {
  List<Datas> _data = List();
  var _currentIndex = 0;

  // 设置数据
  /// 是否已加载完所有数据
  var _loadFinish = false;

  /// 是否正在加载数据
  bool isLoading = false;

  /// listView的控制器
  ScrollController _scrollController = ScrollController();
  double width = 0;

  // banner数组
  List<BannerData> banners = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pullNet();

    // 监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_loadFinish) _getMore();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("玩安卓"),
        centerTitle: true,
      ),
      body: _data.isEmpty
          ? LoadingWidget()
          : ListView.builder(
              itemBuilder: _renderRow,
              itemCount:
                  _loadFinish ? _data.length * 2 + 1 : _data.length * 2 + 2,
              controller: _scrollController,
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _renderRow(BuildContext context, int index) {
    if (index == 0) {
      return _top();
    } else if (index % 2 == 0) {
      if (index == _data.length * 2)
        return Divider(height: 0, color: Colors.transparent);
      return Divider(height: 0.5, color: c9);
    } else if (index % 2 == 1) {
      int i = (index / 2).ceil() - 1;
      if (i < _data.length) {
        return WanListWidget(info: _data[i]);
      }
    }
    return _getMoreWidget();
  }

  void _pullNet() async {
    await WanAndroidApi.getBanner().then((WanBannerInfo info) {
      if (info.data.isNotEmpty) {
        banners.addAll(info.data);
      }
    });

    // 请求主页内容
    WanAndroidApi.getHomeList(_currentIndex, "").then((WanList list) {
      isLoading = false;
      // 不设置setState, 会阻塞列表内容的获取;
      setState(() {
        if (list.data.datas.isEmpty) {
          _loadFinish = true;
        } else {
          _data.addAll(list.data.datas);
        }
      });
    }).catchError((onErroe) {
      isLoading = false;
    });
  }

  /// 上拉加载更多
  void _getMore() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      _currentIndex++;
      _pullNet();
    }
  }

  Widget _top() {
    return Column(
      key: Key('_header_'),
      children: _pageSelector(context),
    );
  }

  List<Widget> _pageSelector(BuildContext context) {
    List<Widget> list = [];
    if (banners.length > 0) {
      list.add(WanBanner(banners, (slider) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new WebPage(
            url: slider.url,
            title: slider.title,
          );
        }));
      }));
    }
    return list;
  }

  /// 加载更多时显示的组件,给用户提示
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }
}
