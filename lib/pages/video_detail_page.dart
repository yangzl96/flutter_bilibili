import 'dart:convert';
import 'dart:io';

import 'package:bilibili/config/index.dart';
import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/favorite_like_dao.dart';
import 'package:bilibili/http/dao/video_detail_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/model/video_detail_model.dart';
import 'package:bilibili/utils/toast.dart';
import 'package:bilibili/widgets/app_bar.dart';
import 'package:bilibili/widgets/expandable_content.dart';
import 'package:bilibili/widgets/hi_tabs.dart';
import 'package:bilibili/widgets/navigation_bar.dart';
import 'package:bilibili/widgets/video_header.dart';
import 'package:bilibili/widgets/video_lage_card.dart';
import 'package:bilibili/widgets/video_tool_bar.dart';
import 'package:bilibili/widgets/video_view.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoInfo;
  VideoDetailPage(this.videoInfo);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  /// 视频信息
  VideoModel? _videoInfo;

  /// 详情信息
  VideoDetailModel? detailInfo;

  /// 视频列表
  List<VideoModel> _videoList = [];

  TabController? _controller;
  List tabs = ['简介', '评论'];
  @override
  void initState() {
    super.initState();
    setState(() {
      _videoInfo = widget.videoInfo;
    });
    //黑色状态栏，仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // IOS环境 移除顶部padding
        body: MediaQuery.removePadding(
            removeTop: Platform.isIOS,
            context: context,
            child: _videoInfo!.url != null
                ? Column(
                    children: [
                      NavigationBar(
                          color: Colors.black,
                          height: Platform.isAndroid ? 0 : 46,
                          statusStyle: StatusStyle.LIGHT_CONTENT),
                      _buildVideoView(),
                      _buildTabNavigation(),
                      Flexible(
                          child: TabBarView(
                        controller: _controller,
                        children: [
                          _buildDetailList(),
                          const SizedBox(
                            child: Text('敬请期待'),
                          )
                        ],
                      ))
                    ],
                  )
                : Container()));
  }

  _buildVideoView() {
    String videoUrl = 'http://${Config.BASE_URL}${_videoInfo!.url}';
    String cover = 'http://${Config.BASE_URL}${_videoInfo!.cover}';
    return VideoView(
      videoUrl,
      cover: cover,
      overlayUI: videoAppBar(),
    );
  }

  // 底部有阴影的tab
  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey.shade100,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.live_tv_rounded, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(text: name);
      }).toList(),
      controller: _controller,
    );
  }

  // 详情列表
  _buildDetailList() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  List<Widget> buildContents() {
    return [
      // 作者
      VideoHeader(owner: _videoInfo!.owner),
      ExpandableContent(videoModel: _videoInfo!),
      VideoToolBar(
        detailInfo: detailInfo,
        videoInfo: _videoInfo!,
        onLike: _onLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  // 点赞
  void _onLike() async {
    try {
      // 用户id
      int userId = 1;
      // 1点赞 0 取消
      int isLike = detailInfo!.isLike ? 0 : 1;
      // 1收藏 0取消
      int isFavorite = detailInfo!.isFavorite == true ? 1 : 0;
      // 视频id
      int? videoId = _videoInfo!.id;
      print(videoId);
      await FavoriteLikeDao.favoriteOrLike(
          userId, videoId!, isLike, isFavorite, 1);
      // 手动赋值改变页面显示
      detailInfo!.isLike = !detailInfo!.isLike;
      if (isLike == 1) {
        _videoInfo!.like = _videoInfo!.like! + 1;
      } else {
        _videoInfo!.like = _videoInfo!.like! - 1;
      }
      setState(() {
        _videoInfo = _videoInfo;
        detailInfo = detailInfo;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  // 不喜欢
  void _onUnLike() {}
  // 收藏/取消收藏
  void _onFavorite() async {
    try {
      int userId = 1;
      int isFavorite = detailInfo!.isFavorite ? 0 : 1;
      int isLike = detailInfo!.isLike == true ? 1 : 0;
      int? videoId = _videoInfo!.id;
      await FavoriteLikeDao.favoriteOrLike(
          userId, videoId!, isLike, isFavorite, 2);
      detailInfo!.isFavorite = !detailInfo!.isFavorite;
      if (detailInfo!.isFavorite) {
        _videoInfo!.favorite = _videoInfo!.favorite! + 1;
      } else {
        _videoInfo!.favorite = _videoInfo!.favorite! - 1;
      }
      setState(() {
        _videoInfo = _videoInfo;
        detailInfo = detailInfo;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  void _loadData() async {
    try {
      VideoDetailModel result = await VideoDetailDao.get(_videoInfo!.id ?? 0);
      setState(() {
        // 详情数据
        detailInfo = result;
        // 更新旧的数据
        _videoInfo = result.videoInfo;
        // 推荐列表
        _videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _buildVideoList() {
    return _videoList
        .map((VideoModel videoInfo) => VideoLargeCard(videoInfo: videoInfo))
        .toList();
  }
}
