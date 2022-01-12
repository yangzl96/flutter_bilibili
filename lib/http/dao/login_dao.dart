// dao层: 数据访问对象层、用于数据的操作
// 比如：在dao层和服务端进行通信，离不开数据交互，和数据库的交互也可以放在dao层
// 数据交互的部分、数据持久化的部分

import 'package:bilibili/db/hi_cache.dart';
import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/base_request.dart';
import 'package:bilibili/http/request/login_request.dart';
import 'package:bilibili/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = 'boarding-pass';
  static login(String username, String password) {
    return _send(username, password);
  }

  static registration(String username, String password, String hobbies) {
    return _send(username, password, hobbies: hobbies);
  }

  static _send(String username, String password, {hobbies}) async {
    BaseRequest request;
    // 区分登录与注册
    if (hobbies != null) {
      request = RegistrationRequest();
      request.add('hobbies', hobbies);
    } else {
      request = LoginRequest();
    }
    // 添加参数
    request.add('username', username).add('password', password);
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 200 && result['data'] != null) {
      //保存登录令牌
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
      print('SAVE_TOKEN------');
      print(HiCache.getInstance().get(BOARDING_PASS));
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
