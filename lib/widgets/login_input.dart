import 'package:bilibili/utils/color.dart';
import 'package:flutter/material.dart';

// 登录input
class LoginInput extends StatefulWidget {
  final String title;
  final String? hint;
  final ValueChanged<String>? onChanged; //change
  final ValueChanged<bool>? focusChanged; //foucs
  final bool lineStretch; // 底部border是否填满整个宽度
  final bool obscureText; // 是否显示密码
  final TextInputType? keyboardType; //键盘类型

  LoginInput(
      {Key? key,
      required this.title,
      this.hint,
      this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType})
      : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 是否获取到光标的监听
    _focusNode.addListener(() {
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                padding: EdgeInsets.only(left: 15),
                width: 100,
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 16),
                )),
            _input()
          ],
        ),
        // 底部的边框： 单独做 比直接在textinput中好处理
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: const Divider(
            height: 1,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofocus: !widget.obscureText,
      cursorColor: primary,
      style: TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
      // 输入框的样式
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: InputBorder.none,
          hintText: widget.hint ?? '',
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
    ));
  }
}
