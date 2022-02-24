import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/rank_request.dart';
import 'package:bilibili/model/ranking_model.dart';

class RankingDao {
  static get(String rankType, {int pageIndex = 1, int pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request.pathParams = rankType;
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    // print(result);
    return RankingModel.fromJson(result['data']);
  }
}
