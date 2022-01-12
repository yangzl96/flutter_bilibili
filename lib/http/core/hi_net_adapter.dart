import 'dart:convert';

import 'package:bilibili/http/request/base_request.dart';

//网络请求抽象类 为了适配不同类型的请求 比如 mock test dev prod 的时候
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

// 统一网络层返回格式 返回T类型 增加灵活度
class HiNetResponse<T> {
  HiNetResponse(
      {this.data,
      required this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});
  T? data;
  BaseRequest request;
  int? statusCode;
  String? statusMessage;
  dynamic extra;
  // 重构toString方法
  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
