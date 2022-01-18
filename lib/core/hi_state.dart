// 解决页面销毁的时候调用了setState 之后会报错的问题
// 重写 state 类中的 setState方法

import 'package:flutter/material.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      print('Histate: 页面已经销毁，本次setState不执行：${toString()}');
    }
  }
}
