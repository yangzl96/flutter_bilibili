import 'package:bilibili/db/hi_cache.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/pages/home.dart';
import 'package:bilibili/pages/login.dart';
import 'package:bilibili/pages/registration.dart';
import 'package:bilibili/pages/video_detail.dart';
import 'package:bilibili/utils/color.dart';
import 'package:bilibili/utils/toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  final BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
      // 运行初始化
      future: HiCache.preInit(),
      builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
        // 定义route 如果future还在加载则返回loading
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(
                routerDelegate: _routeDelegate,
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        // HiCache.getInstance().remove(LoginDao.BOARDING_PASS);
        return MaterialApp(
          home: widget,
          theme: ThemeData(primarySwatch: white),
        );
      },
    );
  }
}

// 路由代理 路由控制的逻辑
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;
  // navigationKey初始化
  // 为Navigator设置一个key,必要的时候可以通过navigationKey.currentState来获取NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现路由跳转逻辑 注册 关联外部 HiNavigator
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        videoModel = args!['videoMo'];
      }
      notifyListeners();
    }));
  }
  RouteStatus _routeStatus = RouteStatus.home; //默认首页
  // 对路由堆栈的管理，整个路由是一个数组，每次打开一个页面往里面添加一个页面
  // 如果这个页面在原有的页面数组中已经存在了，那么会将他以及他上面的页面都清空，
  // 然后创建一个新的页面
  List<MaterialPage> pages = []; //存放所有的页面
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 打开的页面已经存在，则将该页面和他上面的所有页面进行出栈
      tempPages = tempPages.sublist(0, index);
      // 如果想复用当前打开的页面就 - 1 但是要考虑负值的情况
      // 也就是裁切的时候不将当前页面裁切，只裁切当前页面上面的页面
      // 这个事就就会复用了
      // tempPages = tempPages.sublist(0, index - 1);
    }
    var page; //要创建的页面
    if (routeStatus == RouteStatus.home) {
      // 跳转首页的时候将栈中的其他页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(HomePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }

    // 重新创建一个新的数组，否则pages因引用没有改变 路由不会生效
    tempPages = [...tempPages, page];

    // 通知路由发生变化 tempPages:新的 ，pages:未赋值前是旧的
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
      //  fix Android物理返回键，无法返回上一个的问题
      // onWillPop: 是否可返回的方法 ,maybePop的返回值决定
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            // 登录页未登录点击返回按钮时拦截
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showToast('请先登录');
                return false;
              }
            }
          }
          // 在这里控制是否可以回退
          if (!route.didPop(result)) {
            return false;
          }
          // 先存一份变化前的页面数组
          var tempPages = [...pages];
          // 返回上一页后删除栈顶的页面
          pages.removeLast();
          // 移除页面后，再次通知路由变化
          HiNavigator.getInstance().notify(pages, tempPages);
          return true;
        },
      ),
    );
  }

  // 获取 routeStatus 的状态 路由的拦截
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin {
    return LoginDao.getBoardingPass() != null;
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

// 泛型：定义路有数据
class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = '/';
  BiliRoutePath.detail() : location = '/detail';
}
