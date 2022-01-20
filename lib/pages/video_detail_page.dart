import 'dart:io';

import 'package:bilibili/config/index.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/widgets/app_bar.dart';
import 'package:bilibili/widgets/expandable_content.dart';
import 'package:bilibili/widgets/hi_tabs.dart';
import 'package:bilibili/widgets/navigation_bar.dart';
import 'package:bilibili/widgets/video_header.dart';
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
  TabController? _controller;
  List tabs = ['简介', '评论'];
  @override
  void initState() {
    super.initState();
    //黑色状态栏，仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // IOS环境 移除顶部padding
        body: MediaQuery.removePadding(
            removeTop: Platform.isIOS,
            context: context,
            child: Column(
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
            )));
  }

  _buildVideoView() {
    var model = widget.videoInfo;
    String videoUrl = 'http://${Config.BASE_URL}${model.url}';
    String cover = 'http://${Config.BASE_URL}${model.cover}';
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
      children: [...buildContents()],
    );
  }

  buildContents() {
    return [
      // 作者
      Container(
        child: VideoHeader(owner: widget.videoInfo.owner),
      ),
      ExpandableContent(videoModel: widget.videoInfo)
    ];
  }
}
