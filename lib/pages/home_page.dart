import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/home_dao.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/pages/home_tab_page.dart';
import 'package:bilibili/utils/color.dart';
import 'package:bilibili/utils/toast.dart';
import 'package:bilibili/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:bilibili/core/hi_state.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  //路由监听器
  var listener;
  // 类别
  List<CategoryModel> categoryList = [];
  // 轮播
  List<BannerModel> bannerList = [];

  TabController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: categoryList.length, vsync: this);
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
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    HiNavigator.getInstance().removeListener(listener);
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
            padding: const EdgeInsets.only(top: 30),
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
    return TabBar(
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name ?? '',
              style: const TextStyle(fontSize: 16),
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
      padding: EdgeInsets.only(left: 10, right: 10),
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
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                  )),
            ),
          ),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
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
