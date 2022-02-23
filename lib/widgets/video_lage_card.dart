import 'package:bilibili/config/index.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/utils/format_utils.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/material.dart';

/// 关联视频，视频列表卡片
class VideoLargeCard extends StatelessWidget {
  final VideoModel videoInfo;
  VideoLargeCard({Key? key, required this.videoInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
          padding: const EdgeInsets.only(bottom: 6),
          height: 106,
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [_itemImage(context), _buildContent()],
          ),
        ));
  }

  // 图片
  _itemImage(BuildContext context) {
    var videoCover = 'http://${Config.BASE_URL}${videoInfo.cover}';
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoCover, width: height * (16 / 9), height: height),
          Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  durationTransform(videoInfo.duration ?? 0),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ))
        ],
      ),
    );
  }

  // 右边内容
  _buildContent() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(top: 5, left: 8, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            videoInfo.title ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _buildBottomContent()
        ],
      ),
    ));
  }

  _buildBottomContent() {
    return Column(
      children: [
        // 作者
        _owner(),
        hiSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...smallIconText(Icons.ondemand_video, videoInfo.view),
                hiSpace(width: 5),
                ...smallIconText(Icons.list_alt, videoInfo.reply)
              ],
            ),
            const Icon(
              Icons.more_vert_sharp,
              color: Colors.grey,
              size: 15,
            )
          ],
        )
      ],
    );
  }

  _owner() {
    var owner = videoInfo.owner;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey)),
          child: const Text(
            'Up',
            style: TextStyle(
                color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
        hiSpace(width: 8),
        Text(
          owner!.username!,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        )
      ],
    );
  }
}
