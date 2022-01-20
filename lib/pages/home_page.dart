import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/pages/home_tab_page.dart';
import 'package:bilibili/pages/profile_page.dart';
import 'package:bilibili/pages/video_detail_page.dart';
import 'package:bilibili/utils/color.dart';
import 'package:bilibili/utils/toast.dart';
import 'package:bilibili/widgets/hi_tabs.dart';
import 'package:bilibili/widgets/navigation_bar.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:bilibili/core/hi_state.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// AutomaticKeepAliveClientMixin 缓存
// TickerProviderStateMixin  TabController
// WidgetsBindingObserver 生命周期的监听

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  //路由监听器
  var listener;
  // 类别
  List<CategoryModel> categoryList = [];
  // 轮播
  List<BannerModel> bannerList = [];

  TabController? _controller;

  // 当前页面
  Widget? _currenPage;
  @override
  void initState() {
    super.initState();
    // 生命周期监听
    WidgetsBinding.instance!.addObserver(this);
    _controller = TabController(length: categoryList.length, vsync: this);
    // PageView切换页面的时候会重新加载页面
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      _currenPage = current.page;
      print('home: current: ${current.page}');
      print('home: pre: ${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页：onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页：onPause');
      }
      // fix ios在视频详情页的时候是白底黑字，切换到首页的时候，变成了白底白字 看不清状态栏了
      if (pre!.page is VideoDetailPage && current! is ProfilePage) {
        // 这个时候恢复状态栏 ProfilePage的状态栏是沉浸式的所以要排除
        changeStatusBar(
            color: Colors.white, statusStyle: StatusStyle.DART_CONTENT);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    HiNavigator.getInstance().removeListener(listener);
  }

  // 监听生命周期的变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.inactive: //处于这种状态的应用程序应该假设他们可能在任何时候暂停
        break;
      case AppLifecycleState.resumed: //从后台切换到前台，也就是界面切到手机主界面后再切回来的显示的时候
        // fix android将app切换不显示的时候(压入后台)，再次回来后状态栏字体颜色变成了白色
        // 导致上面的文字看不清楚了
        // 只有不在视频详情页的时候 去重置状态栏（视频详情页的bar不一样）
        if (_currenPage is! VideoDetailPage) {
          changeStatusBar(
              color: Colors.white, statusStyle: StatusStyle.DART_CONTENT);
        }
        break;
      case AppLifecycleState.paused: //界面不可见的时候
        break;
      case AppLifecycleState.detached: //app结束的时候
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); 去除build的警告
    return Scaffold(
      body: Column(
        children: [
          NavigationBar(
            height: 50,
            child: _appBar(),
            color: Colors.white,
            statusStyle: StatusStyle.DART_CONTENT,
          ),
          // tab
          Container(
            color: Colors.white,
            // padding: const EdgeInsets.only(top: 1),
            child: _tabBar(),
          ),
          // tabView
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: categoryList.map((tab) {
              return HomeTabPage(
                categoryName: tab.name!,
                bannerList: tab.name == '推荐' ? bannerList : null,
              );
            }).toList(),
          ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(text: tab.name);
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  // 加载首页数据
  loadData() async {
    try {
      HomeModel result = await HomeDao.get('推荐');
      if (result.categoryList != null) {
        // tab长度变化后需要重新创建 TabController
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Image(
                height: 40,
                width: 40,
                image: AssetImage('assets/images/noface.jpg'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                  )),
            ),
          ),
          const Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
