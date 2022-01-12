import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {
  final bool protect;
  const LoginEffect({Key? key, required this.protect}) : super(key: key);

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          const Image(
              height: 90,
              width: 90,
              image: AssetImage('assets/images/logo.png')),
          _image(false),
        ],
      ),
    );
  }

  _image(bool left) {
    // 左边图片
    var headLeft = widget.protect
        ? 'assets/images/head_left_protect.png'
        : 'assets/images/head_left.png';
    // 右边图片
    var headRight = widget.protect
        ? 'assets/images/head_right_protect.png'
        : 'assets/images/head_right.png';
    return Image(
      height: 90,
      image: AssetImage(left ? headLeft : headRight),
    );
  }
}
