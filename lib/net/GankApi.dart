import 'package:gank_flutter/models/DailyInfo.dart';
import 'package:gank_flutter/models/HistoryList.dart';
import 'package:gank_flutter/models/MsgInfo.dart';
import 'package:gank_flutter/models/PageList.dart';
import 'package:gank_flutter/net/HttpGank.dart';

/// gank信息获取
class GankApi{

  // 异步加载async
  Future<PageList> getListData(String type, int count, int pageIndex) async{
    var response = await HttpGank.getJson("data/$type/$count/$pageIndex", {});
    return PageList.fromJson(response);
  }

  // 获取每日资讯
  static Future<DailyInfo> getDailyInfo(String date) async {
    var response = await HttpGank.getJson("day/$date", {});
    return DailyInfo.fromJson(response);
  }

  // 获取每日资讯，今天
  static Future<DailyInfo> getToday() async {
    var response = await HttpGank.getJson("today", {});
    return DailyInfo.fromJson(response);
  }

  static Future<HistoryList> getHistory(int count, int pageIndex) async {
    var response =
    await HttpGank.getJson("history/content/$count/$pageIndex", {});
    return HistoryList.fromJson(response);
  }

  static Future<MsgInfo> release(Map<String, dynamic> map) async {
    var response = await HttpGank.postForm("add2gank", map);
    return MsgInfo.fromJson(response);
  }


}