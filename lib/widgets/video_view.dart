import 'package:bilibili/utils/color.dart';
import 'package:bilibili/widgets/hi_video_controls.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String url; //地址
  final String cover; // 封面
  final bool autoPlay;
  final bool looping; //循环播放
  final double aspectRatio; // 缩放比例
  final Widget? overlayUI; //顶部浮层
  VideoView(this.url,
      {Key? key,
      required this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      this.overlayUI})
      : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  // video_player播放器Controller
  late VideoPlayerController _videoPlayerController;

  /// chewie播放器Controller
  late ChewieController _chewieController;

  // 封面 撑开布局
  get _placeholder =>
      FractionallySizedBox(widthFactor: 1, child: cachedImage(widget.cover));

  // 进度条颜色
  get _progressColors => ChewieProgressColors(
        playedColor: primary, //播放状态下颜色
        handleColor: primary, //拖动状态下颜色
        backgroundColor: Colors.grey, //进度条底色
        bufferedColor: primary.shade50, //缓冲状态下颜色
      );

  @override
  void initState() {
    super.initState();
    // 初始化播放器设置
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        placeholder: _placeholder, //封面
        materialProgressColors: _progressColors, //播放器进度颜色
        customControls: MaterialControls(
          showLoadingOnInitialize: false, //初始化是否显示Loading
          showBigPlayIcon: false, //是否显示中间大的播放按钮
          bottomGradient: blackLinearGradient(), //线性渐变 让底部深一点
          overlayUI: widget.overlayUI, // 播放器顶部的图层
        ));

    // 监听
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _chewieController.removeListener(_fullScreenListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  // 屏幕放大缩小的时候会触发
  void _fullScreenListener() {
    print('screen listener');
    Size size = MediaQuery.of(context).size;
    // 小屏时：Size(360.0, 640.0)
    // 全屏时：Size(640.0, 360.0)
    print(size);
    // 解决由放大到缩小的时候报错的问题
    if (size.width < size.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
