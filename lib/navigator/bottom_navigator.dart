import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/pages/favorite_page.dart';
import 'package:bilibili/pages/home_page.dart';
import 'package:bilibili/pages/profile_page.dart';
import 'package:bilibili/pages/ranking_page.dart';
import 'package:bilibili/utils/color.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  List<Widget>? _pages; //底部页面
  bool _hasBuild = false; //是否是第一次打开

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(
        onJumpTo: (index) => _onJumpTo(index, pageChange: false),
      ),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    if (!_hasBuild) {
      // 首次打开 确定导航位置 通知路由变化。通知打开的是哪个tab
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, _pages![initialPage]);
      _hasBuild = true;
    }
    return Scaffold(
      // PageView切换页面的时候会重新加载页面
      body: PageView(
          controller: _controller,
          children: _pages!,
          // 滑动翻页的时候 也让底部导航变化
          onPageChanged: (index) => _onJumpTo(index, pageChange: true)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index), //第二个参数默认false
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        label: title,
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ));
  }

  // pageChange 区分是点击的底部导航还是滑动切换的
  void _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      // 点击底部导航的时候才jumpToPage
      // jumpToPage 的时候不需要通知路由 因为他会回调 onPageChanged
      _controller.jumpToPage(index);
    } else {
      // 滑动切换的时候
      // 通知路由变化
      HiNavigator.getInstance().onBottomTabChange(index, _pages![index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
