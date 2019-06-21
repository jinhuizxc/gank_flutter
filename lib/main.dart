import 'package:flutter/material.dart';
import 'package:gank_flutter/colors.dart';

import 'gank/MainPage.dart';


/*
 * flutter开发的干货集中营客户端
 * https://github.com/fujianlian/GankFlutter
 *
 * 模仿学习
 *
 * Flutter JSON序列化自动构建
 * https://blog.csdn.net/act64/article/details/89385429
 *
 * flutter常用插件
 * https://blog.csdn.net/julystroy/article/details/88032768
 *
 * Flutter json转实体类（插件自动生成）
 * https://blog.csdn.net/yuzhiqiang_1993/article/details/88533166
 *
 * flutter打包发布apk;
 * https://www.jianshu.com/p/fabcfd621e01
 * https://www.cnblogs.com/gdsblog/p/10100972.html
 *
 * 打包apk命令:  flutter build apk
 *
 * 生成apk路径, 但是没看到到;
 * Built build\app\outputs\apk\release\app-release.apk (6.1MB).
 *
 * 在设备上安装发行版APK#
 * 用USB您的Android设备连接到您的电脑
 * cd .
 * 运行 flutter install .
 *
 *  未打包apk: 35.41M
 *  打包后:6.21M
 *
 * 遇到的坑:
 * flutter -webview 报错 err_cleartext_not_permitted(与原生类似)
 * https://www.cnblogs.com/gggggggxin/p/10518324.html
 *
 *
 */
// 程序入口
void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Study",
      theme: ThemeData(
        primarySwatch: mainColor,
        scaffoldBackgroundColor: Color(0xFFF7F7F7),
      ),
      home: MainPage(),
    );
  }
}

/*
 * primaryColor:
 */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // 复写方法
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter App",
      theme: ThemeData(
        primaryColorDark: Colors.blue,
      ),
      home: MyHomePage(title: "Flutter gank"), // 显示标题
    );
  }
}

// 写完一个语句, 以分号结尾, 控件内部用逗号，定义变量用分号;
class MyHomePage extends StatefulWidget {
  final String title;

  // 构造方法
  MyHomePage({Key key, this.title}) : super(key: key);

  // 复写方法, 定义方法
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// 组件: Column、Center
class _MyHomePageState extends State<MyHomePage> {
  // 定义一个变量
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.start/center/end/spaceAround/spaceBetween/spaceEvenly
          mainAxisAlignment: MainAxisAlignment.center, // 设置child显示位置
          children: <Widget>[
            Text("You have pushed the button this many times:"),
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.display1,  // textTheme/accentTextTheme:颜色显示不同， display1/2/3/4对应字体显示大小
            )
          ],
        ),
      ),
      // 定义floatingActionButton按钮
      floatingActionButton:
          FloatingActionButton(onPressed: _incrementCounter,
          tooltip: "Increment",
          child: Icon(Icons.add),), // 定义按钮方法
    );
  }

}

