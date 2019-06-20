import 'package:flutter/material.dart';
import 'package:gank_flutter/gank/AboutPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

//class MyPage extends StatelessWidget{
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("MyPage"),
//      ),
//    );
//  }
//
//}

class MyPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("MyPage"),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyPageState();
  }
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  static var _color = Color(0xFFFCFCFC);
  static BuildContext _context;
  SharedPreferences _prefs;
  String _avatarUrl = "";
  String _name = "";
  var _isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfo();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("我的"),
        backgroundColor: Colors.red,
        elevation: 10,
      ),
      body: new Container(
        color: Color(0xFFF0F0F0),
        // 显示列表
        child: ListView(
          children: <Widget>[_line()],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // 获取信息
  Future _getInfo() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _refreshInfo();
    }
  }

  void _refreshInfo() {
    setState(() {
      _isLogin = _prefs.getBool("isLogin") ?? false;
      _avatarUrl = _prefs.getString("avatar_url") ?? "";
      _name = _prefs.getString("name") ?? "";
    });
  }

  Widget _line() {
    return new Container(
      margin: EdgeInsets.only(top: 15.0),
      color: _color,
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: Text(
              "点个star",
              style: TextStyle(fontSize: 18.0, color: Colors.blue),
            ),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            // 点击事件
            onTap: () {
              launch("https://github.com/fujianlian/GankFlutter");
            },
            // 长按事件
            onLongPress: () {
              Fluttertoast.showToast(msg: "长按事件触发");
            },
          ),
          // 设置padding间距
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            // 设置分割线
            child: Divider(
              height: 5.0,
            ),
          ),
          new ListTile(
            title: Text("提问", style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              launch("https://github.com/fujianlian/GankFlutter/issues");
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 5.0),
          ),
          new ListTile(
            title: Text("关于", style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            // 路由跳转AboutPage页面
            onTap: () {
              Navigator.push(_context,
                  new MaterialPageRoute(builder: (context) {
                return new AboutPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
