import 'package:bilibili/http/core/dio_adapter.dart';
import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/core/hi_net_adapter.dart';
import 'package:bilibili/http/core/mock_adapter.dart';
import 'package:bilibili/http/request/base_request.dart';

class HiNet {
  HiNet._();

  static HiNet? _instance;

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  // 请求接口
  Future fire(BaseRequest request) async {
    print('开始请求-----------');
    HiNetResponse? response;
    var error;
    try {
      // send 触发适配器 适配器内部去请求并返回结果
      response = await send(request);
      print('success-------------');
    } on HiNetError catch (e) {
      print('HiNetError--------------');
      //先尝试捕获我们定义好的错误
      error = e;
      response = e.data;
      print(response);
      printLog(e.message);
    } catch (e) {
      print('CatchError --------');
      // catch 最后兜底
      error = e;
      printLog(e);
    }

    if (response == null) {
      print('response is null ------------------------------');
      printLog(error);
    }

    var result = response?.data;
    print('请求结果：$result');
    print('-----------------------------------');

    // 处理响应返回结果
    var status = response?.statusCode;
    var hiError;
    switch (status) {
      case 200:
        return result;
      case 510:
        return result;
      case 401:
        hiError = NeedLogin();
        break;
      case 403:
        hiError = NeedAuth(result.toString(), data: result);
        break;
      default:
        // 如果 error 不为空，则复用现有的 error
        hiError =
            error ?? HiNetError(status ?? -1, result.toString(), data: result);
        break;
    }

    throw hiError;
  }

  // 发送请求 返回类型 dynamic send<T> 添加泛型方便拓展
  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url: ${request.url()}');
    printLog('method: ${request.httpMethod()}');
    // request.addHeader('token', '1111');
    // printLog('header: ${request.header}');
    // return Future.value({
    //   'statusCode': 200,
    //   'data': {'code': 0,'message':'success'}
    // });

    // 可以切换不同的适配器来测试不同类型的请求
    // HiNetAdapter adapter = MockAdapter();
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  printLog(msg) {
    print('printLog: ${msg.toString()}');
  }
}
