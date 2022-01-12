import 'package:bilibili/utils/color.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback? onPressed;

  const LoginButton(this.title, {Key? key, this.enable = true, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //FractionallySizedBox:可以使用百分比控制子控件大小。
    return FractionallySizedBox(
      widthFactor: 1, //填满整个宽度
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 45,
        disabledColor: primary[50],
        color: primary,
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
        onPressed: enable ? onPressed : null,
      ),
    );
  }
}
