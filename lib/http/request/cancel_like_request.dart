import 'package:bilibili/http/request/base_request.dart';
import 'package:bilibili/http/request/favorite_like_request.dart';

class CancelLikeRequest extends FavoriteLikeRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
