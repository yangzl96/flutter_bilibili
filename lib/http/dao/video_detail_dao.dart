import 'package:bilibili/http/core/hi_net.dart';
import 'package:bilibili/http/request/video_detail.dart';
import 'package:bilibili/model/video_detail_model.dart';

//详情页面
class VideoDetailDao {
  static get(int vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return VideoDetailModel.fromJson(result['data']);
  }
}
