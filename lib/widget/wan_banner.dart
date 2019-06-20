import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gank_flutter/colors.dart';
import 'package:gank_flutter/models/BannerData.dart';

class WanBanner extends StatefulWidget {
  final List<BannerData> bannerStories;
  final OnTapBannerItem onTap;

  WanBanner(this.bannerStories, this.onTap, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannerState();
  }
}

class _BannerState extends State<WanBanner> {
  int virtualIndex = 0;
  int realIndex = 1;
  PageController controller;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: realIndex);
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      // 自动滚动
      /// print(realIndex);
      controller.animateToPage(realIndex + 1,
          duration: Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
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
    var width = MediaQuery.of(context).size.width;
    return new Container(
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
    // 不设置状态, 底部圆点始终在第一个位置;
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
          .map((banner) => _buildItem(banner))
          .toList(growable: false));
      // 尾部
      items.add(_buildItem(widget.bannerStories[0]));
    }
    return items;
  }

  Widget _buildItem(BannerData banner) {
    return GestureDetector(
      onTap: () {
        // 按下
        if (widget.onTap != null) {
          widget.onTap(banner);
        }
      },
      child: Image.network(banner.imagePath, fit: BoxFit.fill),
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

typedef void OnTapBannerItem(BannerData banner);
