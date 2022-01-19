/// 数字转万
String countFormat(int count) {
  String views = "";
  if (count > 9999) {
    views = "${(count / 10000).toStringAsFixed(2)}万";
  } else {
    views = count.toString();
  }
  return views;
}

/// 时间转换将秒转换为分钟:秒
String durationTransform(int seconds) {
  // 获取有多少分钟
  int m = (seconds / 60).truncate();
  // 减去分钟还剩多少秒
  int s = seconds - m * 60;
  if (s < 10) {
    return '$m:0$s';
  }
  return '$m:$s';
}
