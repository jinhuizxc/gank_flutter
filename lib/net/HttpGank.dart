import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';

/// http请求
class HttpGank {
  static final debug = !bool.fromEnvironment("dart.vm.product");

  // 服务器路径
  static final baseUrl = 'https://gank.io/api/';

  // 基础信息配置
  static final Dio _dio = new Dio(new BaseOptions(
    method: 'get',
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
    followRedirects: true,
  ));

  // 拦截器设置
  static void setInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
      // 当请求失败时做一些预处理
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        // none、mobile、wifi
        e.message = "网络连接异常，请检查手机网络设置";
      } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        e.message = "网络连接超时";
      } else {
        e.message = "未知错误";
      }
      return e;
    }));
  }

  // 设置请求头
  static void setHeader(Map<String, String> header) {
    _dio.options.headers = header;
  }

  static final HttpError unKnowError = HttpError(-1, "未知异常");

  // 获取json数据
  static Future<Map<String, dynamic>> getJson<T>(
          String uri, Map<String, dynamic> paras) =>
      _httpJson("get", uri, data: paras).then(logicalSuccessTransform);

  // 获取表单数据
  Future<Map<String, dynamic>> getForm<T>(
          String uri, Map<String, dynamic> paras) =>
      _httpJson("get", uri, data: paras, dataIsJson: false)
          .then(logicalSuccessTransform);

  // 表单方式的post
  static Future<Map<String, dynamic>> postForm<T>(
          String uri, Map<String, dynamic> paras) =>
      _httpJson("post", uri, data: paras, dataIsJson: false)
          .then(logicalSuccessTransform);

  // requestBody (json格式参数) 方式的 post
  Future<Map<String, dynamic>> postJson(
          String uri, Map<String, dynamic> body) =>
      _httpJson("post", uri, data: body).then(logicalSuccessTransform);

  static Future<Response<Map<String, dynamic>>> _httpJson(
      String method, String uri,
      {Map<String, dynamic> data, bool dataIsJson = true}) async {
    if (!uri.contains("today")) setInterceptor();
    // 如果为 get方法，则进行参数拼接
    if (method == "get") {
      dataIsJson = false;
      if (data == null) {
        data = new Map<String, dynamic>();
      }
    }

    if (debug) {
      print('请求的url地址: <net url>-------->$uri');
      print('请求的参数: <net params>-------->$data');
    }

    /// 根据当前 请求的类型来设置 如果是请求体形式则使用json格式
    /// 否则则是表单形式的（拼接在url上）
    Options op;
    if (dataIsJson) {
      op = new Options(contentType: ContentType.parse("application/json"));
    } else {
      op = new Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded"));
    }

    op.method = method;
    return _dio.request<Map<String, dynamic>>(method == "get" ? uri : "$uri",
        data: data, options: op);
  }

  /// 对请求返回的数据进行统一的处理
  /// 如果成功则将我们需要的数据返回出去，否则进异常处理方法，返回异常信息
  static Future<Map<String, dynamic>> logicalSuccessTransform<T>(
      Response<Map<String, dynamic>> resp) {
    if (resp.data != null) {
      return Future.value(resp.data);
    } else {
      return Future.value(null);
    }
  }
}

/// 统一异常类
class HttpError {
  int errorCode;
  String msg;

  HttpError(error, msg) {
    this.errorCode = errorCode;
    this.msg = msg;
  }
}
