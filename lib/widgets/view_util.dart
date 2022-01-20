import 'package:bilibili/utils/format_utils.dart';
import 'package:bilibili/widgets/navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 带缓存的图片
Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) => Container(
      color: Colors.grey[200],
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    imageUrl: url,
  );
}

// 黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      // 起始位置
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      // 结束方向
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: const [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent,
      ]);
}

// 修改状态栏颜色
void changeStatusBar(
    {color = Colors.white,
    StatusStyle statusStyle = StatusStyle.LIGHT_CONTENT,
    BuildContext? context}) {}

// 带文字的小图标
smallIconText(IconData iconData, var text) {
  var style = const TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    // 处理数字
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text('$text', style: style)
  ];
}
