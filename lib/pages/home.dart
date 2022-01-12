import 'package:bilibili/model/video_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      print('current: ${current.page}');
      print('current: ${pre.page}');
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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('首页'),
            MaterialButton(
              onPressed: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
                    args: {'videoMo': VideoModel(1001)});
              },
              child: Text('详情'),
            )
          ],
        ),
      ),
    );
  }
}
