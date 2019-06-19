import 'package:flutter/material.dart';


/*
 * flutter开发的干货集中营客户端
 * https://github.com/fujianlian/GankFlutter
 */
// 程序入口
void main() => runApp(MyApp());

//
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // 复写方法
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Flutter gank"), // 显示标题
    );
  }
}

// 写完一个语句, 以分号结尾;
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
              style: Theme.of(context).textTheme.display1,
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
