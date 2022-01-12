// 实现 Exception类
// 网络异常 统一格式类
class HiNetError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  HiNetError(this.code, this.message, {this.data});
}

// 根据需要派生子类

// 需要登陆的异常
class NeedLogin extends HiNetError {
  NeedLogin({int code: 401, String message: '请先登录'}) : super(code, message);
}

// 需要授权的异常
class NeedAuth extends HiNetError {
  // super 去实现父类的方法并传参
  NeedAuth(String message, {int code: 403, dynamic data})
      : super(code, message, data: data);
}
