import 'package:bilibili/pages/ranking_tab_page.dart';
import 'package:bilibili/widgets/hi_tabs.dart';
import 'package:bilibili/widgets/navigation_bar.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  RankingPage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<RankingPage>
    with TickerProviderStateMixin {
  static const tabs = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];

  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_buildNavigationBar(), _buildTabView()],
    ));
  }

  // 导航栏
  _buildNavigationBar() {
    return NavigationBar(
        child: Container(
      decoration: bottomBoxShadow(context),
      alignment: Alignment.center,
      child: _tabBar(),
    ));
  }

  // 主体部分
  _buildTabView() {
    return Flexible(
        child: TabBarView(
            controller: _controller,
            children: tabs.map((tab) {
              return RankingTabPage(sort: tab['name'] as String);
            }).toList()));
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((tab) {
        return Tab(
          text: tab['name'],
        );
      }).toList(),
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      controller: _controller,
    );
  }
}
