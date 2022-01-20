import 'package:bilibili/config/index.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/utils/color.dart';
import 'package:bilibili/utils/format_utils.dart';
import 'package:flutter/material.dart';

// 详情页，作者widget
class VideoHeader extends StatelessWidget {
  final Owner? owner;
  const VideoHeader({Key? key, this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var face = 'http://${Config.BASE_URL}${owner!.face}';
    return Container(
      padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(face, width: 30, height: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(owner!.username!,
                        style: const TextStyle(
                            fontSize: 13,
                            color: primary,
                            fontWeight: FontWeight.bold)),
                    Text('${countFormat(owner!.fans!)}粉丝',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        )),
                  ],
                ),
              )
            ],
          ),
          MaterialButton(
            onPressed: () {},
            color: primary,
            height: 24,
            minWidth: 50,
            child: const Text(
              '关注',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
