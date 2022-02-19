import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/model/video_detail_model.dart';
import 'package:bilibili/utils/color.dart';
import 'package:bilibili/utils/format_utils.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/material.dart';

// 视频点赞分享收藏等工具栏
class VideoToolBar extends StatelessWidget {
  final VideoDetailModel? detailInfo;
  final VideoModel? videoInfo;
  // 喜欢事件
  final VoidCallback? onLike;
  // 不喜欢
  final VoidCallback? onUnLike;
  // 打赏
  final VoidCallback? onCoin;
  // 收藏
  final VoidCallback? onFavorite;
  // 分享
  final VoidCallback? onShare;

  const VideoToolBar({
    Key? key,
    this.detailInfo,
    required this.videoInfo,
    this.onLike,
    this.onUnLike,
    this.onCoin,
    this.onFavorite,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded, videoInfo?.like ?? 0,
              onClick: onLike, tint: detailInfo?.isLike ?? false),
          _buildIconText(
            Icons.thumb_down_alt_rounded,
            '不喜欢',
            onClick: onUnLike,
          ),
          _buildIconText(
            Icons.monetization_on,
            videoInfo!.coin,
            onClick: onCoin,
          ),
          _buildIconText(
            Icons.grade_rounded,
            videoInfo!.favorite,
            onClick: onFavorite,
            tint: detailInfo?.isFavorite ?? false,
          ),
          _buildIconText(
            Icons.share_rounded,
            videoInfo!.share,
            onClick: onShare,
          ),
        ],
      ),
    );
  }

  // tint 是否着色
  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      text = countFormat(text);
    } else if (text == null) {
      text = '';
    }
    tint = tint == null ? false : tint;
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? primary : Colors.grey,
          ),
          hiSpace(height: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
