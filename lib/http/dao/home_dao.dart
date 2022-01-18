
import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/home_request.dart';
import 'package:bilibili/model/home_model.dart';

class HomeDao {
  // https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
  static get(String categoryName, { int pageIndex = 1, int pageSize = 10}) async{
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    // print(result);
    return HomeModel.fromJson(result['data']);
  }
}