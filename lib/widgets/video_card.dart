import 'package:bilibili/config/index.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/utils/format_utils.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoInfo;
  VideoCard({Key? key, required this.videoInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black87;
    return InkWell(
        onTap: () {
          print(videoInfo.url);
        },
        child: SizedBox(
          height: 200,
          child: Card(
              margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _itemImage(context),
                    _infoText(textColor),
                  ],
                ),
              )),
        ));
  }

  // 信息文本
  _infoText(textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(
          top: 5,
          left: 8,
          right: 8,
          bottom: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              videoInfo.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
            _owner(textColor)
          ],
        ),
      ),
    );
  }

  // 作者
  _owner(Color textColor) {
    var owner = videoInfo.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(12),
            //   child: cachedImage(
            //     owner!.face,
            //     height: 24,
            //     width: 24,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner!.username!,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        ),
      ],
    );
  }

  // 图片
  _itemImage(BuildContext context) {
    var videoCover = 'http://${Config.BASE_URL}${videoInfo.cover}';
    final size = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Image.network(
          videoCover,
          width: size / 2 - 10,
          height: 110,
          fit: BoxFit.fill,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 3,
              top: 5,
            ),
            decoration: const BoxDecoration(
              // 渐变
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _iconText(Icons.ondemand_video, videoInfo.view ?? 0),
                _iconText(Icons.favorite_border, videoInfo.favorite ?? 0),
                _iconText(null, videoInfo.duration ?? 0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 图标文本
  _iconText(IconData? iconData, int count) {
    String views = '';
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoInfo.duration!);
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ],
    );
  }
}
