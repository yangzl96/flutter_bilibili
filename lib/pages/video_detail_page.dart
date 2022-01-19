import 'package:bilibili/config/index.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/widgets/video_view.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoInfo;
  VideoDetailPage(this.videoInfo);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [_videoView()],
        ));
  }

  _videoView() {
    var model = widget.videoInfo;
    var videoUrl = 'http://${Config.BASE_URL}${model.url}';
    print(videoUrl);
    return VideoView(videoUrl, cover: model.cover!);
  }
}
