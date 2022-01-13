import 'package:flutter/material.dart';

// 首页顶部导航中的tab的body页面
class HomeTabPage extends StatefulWidget {
  final String? name;
  const HomeTabPage({Key? key, this.name}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.name!);
  }
}
