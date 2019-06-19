import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gank_flutter/models/QQMusic.dart';
import '../colors.dart';

class GankBanner extends StatefulWidget {

  List<Sliders> bannerStories;
  OnTapBannerItem onTap;

  GankBanner(this.bannerStories, this.onTap, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannerState();
  }
}

class _BannerState extends State<GankBanner> {
  int virtualIndex = 0;
  int realIndex = 1;
  PageController controller;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: realIndex);
    // 设置定时时间
    Duration duration = Duration(seconds: 3);
    timer = Timer.periodic(duration, (timer) {
      // 自动滚动
//      print("banner滚动下标, $realIndex");
      controller.animateToPage(realIndex + 1,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: width / 5 * 2.2,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            controller: controller,
            onPageChanged: _onPageChanged,
            children: _buildItems(),
          ),
          _buildIndicator(), // 下面的小点
        ],
      ),
    );
  }

//  _onPageChanged() {}

  void _onPageChanged(int index) {
    realIndex = index;
    int count = widget.bannerStories.length;
    if (index == 0) {
      virtualIndex = count - 1;
      controller.jumpToPage(count);
    } else if (index == count + 1) {
      virtualIndex = 0;
      controller.jumpToPage(1);
    } else {
      virtualIndex = index - 1;
    }
    setState(() {});
  }

  List<Widget> _buildItems() {
    // 排列轮播数组
    List<Widget> items = [];
    if (widget.bannerStories.length > 0) {
      // 头部添加一个尾部Item，模拟循环
      items.add(
          _buildItem(widget.bannerStories[widget.bannerStories.length - 1]));
      // 正常添加Item
      items.addAll(widget.bannerStories
          .map((slider) => _buildItem(slider))
          .toList(growable: false));
      // 尾部
      items.add(_buildItem(widget.bannerStories[0]));
    }
    return items;
  }

  Widget _buildItem(Sliders slider) {
    return GestureDetector(
      onTap: () {
        // 按下
        if (widget.onTap != null) {
          widget.onTap(slider);
        }
      },
      child: Image.network(slider.picUrl, fit: BoxFit.fill),
    );
  }

  Widget _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < widget.bannerStories.length; i++) {
      indicators.add(Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == virtualIndex ? mainColor : Color(0x80ffffff))));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: indicators);
  }
}

typedef void OnTapBannerItem(Sliders slider);
