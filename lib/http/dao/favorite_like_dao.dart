import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/base_request.dart';
import 'package:bilibili/http/request/favorite_like_request.dart';

class FavoriteLikeDao {
  // 点赞、取消点赞、收藏、取消收藏
  // type: 1 点赞 2 收藏
  static favoriteOrLike(
      int userId, int videoId, int isLike, int isFavorite, int type) async {
    BaseRequest request = FavoriteLikeRequest();
    request
        .add('userId', userId)
        .add('videoId', videoId)
        .add('isLike', isLike)
        .add('isFavorite', isFavorite)
        .add('type', type);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
