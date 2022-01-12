import 'package:bilibili/http/core/hi_error.dart';
import 'package:bilibili/http/dao/login_dao.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:bilibili/utils/string_utils.dart';
import 'package:bilibili/utils/toast.dart';
import 'package:bilibili/widgets/app_bar.dart';
import 'package:bilibili/widgets/login_button.dart';
import 'package:bilibili/widgets/login_efect.dart';
import 'package:bilibili/widgets/login_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _protect = false;
  bool loginEnable = false;
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
          child: ListView(
        children: [
          LoginEffect(protect: _protect),
          LoginInput(
            title: '用户名',
            hint: '请输入用户名',
            onChanged: (val) {
              username = val;
              checkInput();
            },
          ),
          LoginInput(
            title: '密码',
            hint: '请输入密码',
            obscureText: true,
            onChanged: (val) {
              password = val;
              checkInput();
            },
            focusChanged: (focus) {
              // 密码聚焦的时候切换图片
              setState(() {
                _protect = focus;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: LoginButton(
              '登录',
              enable: loginEnable,
              onPressed: send,
            ),
          )
        ],
      )),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(username) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(username!, password!);
      print(result);
      if (result['code'] == 200) {
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
