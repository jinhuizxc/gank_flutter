import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gank_flutter/gank/DailyPage.dart';
import 'package:gank_flutter/models/GankInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gank_flutter/models/HistoryList.dart';
import '../colors.dart';
import 'WebPage.dart';

/*
 * 公共组件
 * 1. 加载视图
 * 2. banner/主页显示内容
 * 3.
 */
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: window.physicalSize.height,
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
            new Container(
                padding: EdgeInsets.only(top: 10.0), child: new Text("正在加载")),
          ],
        ),
      ),
    );
  }
}

// 主页列表信息
class HomeListWidget extends StatelessWidget {
  HomeListWidget({Key key, this.info, this.contexts}) : super(key: key);

  final GankInfo info;
  final BuildContext contexts;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new InkWell(
        onTap: () {
          Navigator.push(contexts == null ? context : contexts,
              new MaterialPageRoute(builder: (context) {
            return new WebPage(url: info.url, title: info.desc);
          }));
        },
        child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: _getRowWidget(),
        ),
      ),
    );
  }

  Widget _getRowWidget() {
    return new Column(
      children: <Widget>[
        new Row(
          children: [
            new Expanded(
              child: new Text(
                info.desc,
                maxLines: 3,
                style: new TextStyle(fontSize: 15.0, height: 1.1),
              ),
            ),
            info.images == null || info.images.isEmpty
                ? new Text("")
                : new Container(
                    margin: EdgeInsets.only(left: 8.0, bottom: 5),
                    child: new CachedNetworkImage(
                      placeholder: (context, url) => new Image(
                            image: AssetImage("images/holder.png"),
                            fit: BoxFit.fitHeight,
                            width: 90,
                            height: 90,
                          ),
                      fit: BoxFit.fitHeight,
                      imageUrl: info.images[0],
                      width: 60,
                      height: 90,
                    )),
          ],
        ),
        new Container(
          margin: EdgeInsets.only(top: 7.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  info.who + " · " + info.type,
                  style: new TextStyle(color: c3, fontSize: 12.0),
                ),
              ),
              new Text(
                info.createdAt.substring(0, 10),
                style: new TextStyle(color: c3, fontSize: 12.0),
              )
            ],
          ),
        )
      ],
    );
  }
}

// 干货历史
class HistoryListWidget extends StatelessWidget {
  final HistoryInfo info;

  HistoryListWidget({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp exp = new RegExp(r'src=\"(.+?)\"');
    var imageUrl = exp.firstMatch(info.content).group(1);
    return new Container(
      child: new GestureDetector(
        onTap: () {
          //导航到新路由
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new DailyPage(title: info.publishedAt.substring(0, 10));
          }));
        },
        child: new Container(
          color: Color(0xFFDFDFDF),
          child: new Stack(
            children: <Widget>[
              new Container(
                child: new CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: window.physicalSize.width - 20,
                  height: 170,
                ),
              ),
              new Container(
                margin: EdgeInsets.only(left: 15.0, top: 64, right: 15.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      info.publishedAt.substring(0, 10),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    new Text(
                      info.title,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                ),
              )
            ],
          ),
          margin: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
