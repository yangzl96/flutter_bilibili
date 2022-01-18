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

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? username;
  String? password;
  String? rePassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        // 使用ListView包裹的原因是避免键盘弹起后遮挡了输入框
        child: ListView(
          children: [
            LoginEffect(protect: protect),
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
                  protect = focus;
                });
              },
            ),
            LoginInput(
              title: '确认密码',
              hint: '请再次输入密码',
              obscureText: true,
              onChanged: (val) {
                rePassword = val;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                '注册',
                enable: loginEnable,
                onPressed: checkParams,
              ),
            )
          ],
        ),
      ),
    );
  }

  // 是否可以登录
  void checkInput() {
    bool enable;
    if (isNotEmpty(username) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  // 登录按钮
  Widget _loginButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
        }
      },
      child: Text('注册'),
    );
  }

  void send() async {
    try {
      var result = await LoginDao.registration(username!, password!, 'hobby');
      print(result);
      if (result['code'] == 200) {
        showToast('注册成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
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

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    }
    if (tips != null) {
      showWarnToast(tips);
      return;
    }
    send();
  }
}
