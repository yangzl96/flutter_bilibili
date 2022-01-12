// 测试适配器 mock数据
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future.delayed(const Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": "success"} as T,
          statusCode: 401);
    });
  }
}
