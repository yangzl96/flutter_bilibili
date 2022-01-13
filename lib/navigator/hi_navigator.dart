import 'package:bilibili/pages/home.dart';
import 'package:bilibili/pages/login.dart';
import 'package:bilibili/pages/registration.dart';
import 'package:bilibili/pages/video_detail.dart';
import 'package:flutter/material.dart';

///路由的管理方法

// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

// 获取routerStatus在页面堆栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

// 路由状态
enum RouteStatus { login, registration, home, detail, unknow }

// 获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknow;
  }
}

// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// -----------------------------------------------------
/// 跳转导航
/// 监听路由页面跳转
/// 感知当前页面是否压后台
class HiNavigator extends _RouterJumpListener {
  static HiNavigator? _instance;
  RouteJumpListener? _routeJump;
  final List<RouteChangeListener> _listeners = []; //很多页面都可以监听路由状态的变化所以是数组
  RouteStatusInfo? _current; //打开过的页面
  HiNavigator._();
  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  // 注册路由跳转逻辑
  // main.dart 中的代理路由才是真正可以实现跳转的地方
  // 所以这里提供一个方法 做关联
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJump = routeJumpListener;
  }

  // 监听路由页面跳转
  // 添加监听
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  // 移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  // 通知路由页面变化
  // 什么时候通知？在main.dart中堆栈信息发生变化的时候
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  // 通知所有页面订阅者 页面堆栈信息发生了变化
  void _notify(RouteStatusInfo current) {
    print('hi_navigator:current: ${current.page}');
    print('hi_navigator:pre: ${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current!);
    });
    // 将即将打开的页面赋值给_current,所以_current永远是上一次打开的页面
    _current = current;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args ?? {});
  }
}

///抽象类 供HiNavigator实现
abstract class _RouterJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

// 定义一个跳转方法的类型
typedef OnJumpTo = Function(RouteStatus routeStatus, {Map args});

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
  RouteJumpListener({required this.onJumpTo});
}

// --------------------------------------
// 页面跳转监听的方法类型 监听路由状态的变化
// current： 当前打开的页面
// pre：上次打开的页面
// 封装通知的功能： 打开新页面通知、关闭页面后通知
typedef RouteChangeListener = Function(
    RouteStatusInfo current, RouteStatusInfo pre);
