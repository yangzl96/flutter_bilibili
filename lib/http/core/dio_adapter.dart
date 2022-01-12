import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';
import 'package:dio/dio.dart';

// dio 请求适配器
class DioAdapter extends HiNetAdapter {
  @override
  // 实现 send 方法
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    try {
      switch (request.httpMethod()) {
        case HttpMethod.GET:
          response = await Dio().get(request.url(), options: options);
          break;
        case HttpMethod.POST:
          response = await Dio()
              .post(request.url(), data: request.params, options: options);
          break;
        case HttpMethod.DELETE:
          response = await Dio()
              .delete(request.url(), data: request.params, options: options);
          break;
      }
    } on DioError catch (e) {
      error = e;
      // 这个e.response也是DioError里面的
      response = e.response;
    }
    // 抛出错误
    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: await buildRes(response, request));
    }
    return await buildRes(response, request);
  }

  // 构建返回结果 HiNetResponse
  // Response response 是框架内部的http返回
  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, BaseRequest request) {
    return Future.value(
      HiNetResponse(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response,
      ),
    );
  }
}
