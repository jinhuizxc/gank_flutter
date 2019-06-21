import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gank_flutter/gank/CommonComponent.dart';
import 'package:gank_flutter/models/GankInfo.dart';
import 'package:gank_flutter/models/PageList.dart';
import 'package:gank_flutter/net/GankApi.dart';

// 妹子页面
//class FuliPage extends StatelessWidget{
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("FuliPage"),
//      ),
//    );
//  }
//
//}

class FuliPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new FuliPageState();
  }
}

class FuliPageState extends State<FuliPage> with AutomaticKeepAliveClientMixin {
  List<GankInfo> _data = List();

  var _currentIndex = 1;

  // 设置排列方式
  var _crossAxisCount = 2;

  var _loadFinish = false;

  /// 是否正在加载数据
  bool isLoading = false;

  /// listView的控制器
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pullNet();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_loadFinish) _getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('妹子'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.transform),
              onPressed: () {
                setState(() {
                  if (_crossAxisCount == 2) {
                    _crossAxisCount = 1;
                  } else {
                    _crossAxisCount = 2;
                  }
                });
              })
        ],
      ),
      body: _data.isEmpty
          ? LoadingWidget()
          : Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    childAspectRatio: _crossAxisCount == 1 ? 1 : 0.8,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0),
                itemBuilder: _renderRow,
                itemCount: _loadFinish ? _data.length : _data.length + 1,
                padding: EdgeInsets.all(5.0),
                controller: _scrollController,
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _pullNet() {
    GankApi.getListData("福利", 20, _currentIndex).then((PageList list) {
      isLoading = false;
      setState(() {
        if (list.results.isEmpty) {
          _loadFinish = true;
        } else {
          _data.addAll(list.results);
        }
      });
    });
  }

  void _getMore() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      _currentIndex++;
      _pullNet();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _data.length) {
      return _PhotoItem(info: _data[index]);
    }
    return _getMoreWidget();
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

class _PhotoItem extends StatelessWidget {
  final GankInfo info;

  _PhotoItem({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: new GestureDetector(
        onTap: () {
          _showPhoto(context);
        },
        child: Hero(
            tag: info.url,
            child: new CachedNetworkImage(
              fit: BoxFit.cover,
              placeholder: (context, url) => new Image(
                    image: AssetImage("images/fuli.png"),
                    fit: BoxFit.cover,
                  ),
              imageUrl: info.url,
            )),
      ),
    );
  }

  // 显示图片
  void _showPhoto(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(info.desc),
          centerTitle: true,
        ),
        body: Center(
          child: Hero(
              tag: info.url,
              child: new CachedNetworkImage(
                  imageUrl: info.url, fit: BoxFit.fitWidth)),
        ),
      );
    }));
  }
}
