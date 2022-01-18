import 'package:flutter/material.dart';

enum StatusStyle { LIGHT_CONTENT, DART_CONTENT }

// 可自定义样式的沉浸式导航栏
class NavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;
  const NavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DART_CONTENT,
      this.color = Colors.white,
      this.height = 46,
      this.child})
      : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    // 手机状态栏的高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height + top,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
    );
  }
}
