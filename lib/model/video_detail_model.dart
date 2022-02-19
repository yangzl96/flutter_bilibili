import 'dart:convert';

import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/utils/model_utils.dart';

class VideoDetailModel {
  bool isFavorite;
  bool isLike;
  VideoModel videoInfo;
  List<VideoModel> videoList;

  VideoDetailModel({
    required this.isFavorite,
    required this.isLike,
    required this.videoInfo,
    required this.videoList,
  });

  factory VideoDetailModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<VideoModel>? videoList =
        jsonRes['videoList'] is List ? <VideoModel>[] : null;
    if (videoList != null) {
      for (final dynamic item in jsonRes['videoList']!) {
        if (item != null) {
          videoList.add(VideoModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return VideoDetailModel(
      isFavorite: asT<bool>(jsonRes['isFavorite']) ?? false,
      isLike: asT<bool>(jsonRes['isLike']) ?? false,
      videoInfo:
          VideoModel.fromJson(asT<Map<String, dynamic>>(jsonRes['videoInfo']) ?? {}),
      videoList: videoList ?? [],
    );
  }
  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isFavorite': isFavorite,
        'isLike': isLike,
        'videoInfo': videoInfo,
        'videoList': videoList,
      };
  VideoDetailModel clone() => VideoDetailModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
