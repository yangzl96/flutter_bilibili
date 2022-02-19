
import 'package:bilibili/http/request/base_request.dart';

class FavoriteLikeRequest extends BaseRequest {
  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "/v1/favor/favorLike";
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }
}
