import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/pages/home_tab_page.dart';
import 'package:bilibili/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  TabController? _controller;
  var tabs = ['推荐', '热门', '追播', '影视', '搞笑', '日常', '综合', '手机游戏', '短片·手书·配音'];
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    // PageView切换页面的时候会重新加载页面
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      print('home: current: ${current.page}');
      print('home: pre: ${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页：onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页：onPause');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    HiNavigator.getInstance().removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); 去除build的警告
    return Scaffold(
      body: Column(
        children: [
          // tab
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          // tabView
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: tabs.map((tab) {
              return HomeTabPage(name: tab);
            }).toList(),
          ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      controller: _controller,
      isScrollable: true,
      indicator: const UnderlineIndicator(
          strokeCap: StrokeCap.round,
          insets: EdgeInsets.only(left: 15, right: 15),
          borderSide: BorderSide(color: primary, width: 3)),
      labelColor: Colors.black,
    );
  }
}
