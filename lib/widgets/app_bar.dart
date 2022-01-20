import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/material.dart';

///自定义顶部appBar

appBar(String title, String rightTitle, VoidCallback rightButtonClick) {
  return AppBar(
    // 让title居左
    centerTitle: false,
    titleSpacing: 0,
    leading: BackButton(),
    title: Text(title, style: TextStyle(fontSize: 18)),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

// videoAppBar 视频详情bar
videoAppBar() {
  return Container(
      padding: const EdgeInsets.only(right: 8),
      // decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(
            color: Colors.white,
          ),
          Row(
            children: [
              Icon(
                Icons.live_tv_rounded,
                color: Colors.white,
                size: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 20,
                  ))
            ],
          )
        ],
      ));
}
