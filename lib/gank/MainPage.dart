import 'package:flutter/material.dart';
import 'package:gank_flutter/colors.dart';
import 'package:gank_flutter/gank/FuliPage.dart';
import 'package:gank_flutter/gank/HomePage.dart';
import 'package:gank_flutter/gank/MyPage.dart';
import 'package:gank_flutter/gank/SortPage.dart';
import 'package:gank_flutter/gank/WanPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainPageState();
  }
}

/*
 * IndexedStack: 
 * body 里面有children
 */
class MainPageState extends State<MainPage> {

  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ["最新", "分类", "妹纸", "玩安卓", "我的"];

  /*
   * 根据索引获得对应的normal或是press的icon
   */
  Icon getTabIcons(int index) {
    return tabImages[index];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTiles(int index) {
    if (index == _tabIndex) {
      return new Text(appBarTitles[index], style: TextStyle(color: mainColor));
    } else {
      return new Text(
        appBarTitles[index],
        style: new TextStyle(color: const Color(0xdd888888)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initData();
    // TODO: implement build
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          HomePage(),
          SortPage(),
          FuliPage(),
          WanPage(),
          MyPage(),
        ],
        index: _tabIndex, // 定义下标
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: getTabIcons(0), title: getTabTiles(0)),
          new BottomNavigationBarItem(
              icon: getTabIcons(1), title: getTabTiles(1)),
          new BottomNavigationBarItem(
              icon: getTabIcons(2), title: getTabTiles(2)),
          new BottomNavigationBarItem(
              icon: getTabIcons(3), title: getTabTiles(3)),
          new BottomNavigationBarItem(
              icon: getTabIcons(4), title: getTabTiles(4)),
        ],
        //设置显示的模式fixed/shifting
        type: BottomNavigationBarType.fixed,
        //设置当前的索引
        currentIndex: _tabIndex,
        //tabBottom的点击监听
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }

  void initData() {
    /*
     * bottom的按压图片
     */
    tabImages = [
      Icon(Icons.public),
      Icon(Icons.widgets),
      Icon(Icons.spa),
      Icon(Icons.android),
      Icon(Icons.person),
    ];
  }
}
