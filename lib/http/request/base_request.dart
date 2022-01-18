import 'package:bilibili/config/index.dart';
import 'package:bilibili/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }

// 通过抽象类 封装基础请求
abstract class BaseRequest {
  // 要支持下面两种get
  // http://baseUrl/test?a=1 queryString
  // http://baseUrl/test/a/1 params

  var pathParams;
  var useHttps = false;

  // baseUrl
  String anthority() {
    return Config.BASE_URL;
  }

  // 抽象方法
  HttpMethod httpMethod();

  // 路径
  String path();

  // 生成具体的url地址
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path路径 是否携带 /
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    // http 和 https 切换
    if (useHttps) {
      // String authority, String unencodedPath, [Map<String, dynamic>? queryParameters]
      uri = Uri.https(anthority(), pathStr, params);
    } else {
      uri = Uri.http(anthority(), pathStr, params);
    }
    // 需要登录的接口设置token
    if (needLogin()) {
      var token = LoginDao.getBoardingPass() ?? 'no token';
      addHeader(LoginDao.BOARDING_PASS, token);
    }
    return uri.toString();
  }

  // 接口是否需要登录
  bool needLogin();

  // 存放所有的参数
  Map<String, String> params = Map();

  // 存放header参数
  Map<String, dynamic> header = Map();

  // 添加参数 返回一个 BaseRequest 类型的
  // 这样就可以通过链式调用的方式去添加参数 add().add()....
  // 添加参数
  BaseRequest add(String k, Object v) {
    // key value
    params[k] = v.toString();
    // 返回 BaseRequest
    return this;
  }

  // 添加header
  BaseRequest addHeader(String k, Object v) {
    // key value
    // 添加参数
    header[k] = v.toString();
    // 返回 BaseRequest
    return this;
  }
}
