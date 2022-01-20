import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/widgets/view_util.dart';
import 'package:flutter/material.dart';

// 开展开的widget
class ExpandableContent extends StatefulWidget {
  final VideoModel videoModel;
  ExpandableContent({Key? key, required this.videoModel}) : super(key: key);

  @override
  _ExpandableContentState createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  // 定义动画
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  bool _expand = false; //展开状态
  // 动画的controller
  AnimationController? _controller;
  // 生成动画的高度
  Animation<double>? _heightFactor;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    // 创建高度的动画通过 drive生成 传递曲线
    _heightFactor = _controller!.drive(_easeInTween);
    // 监听动画值的变化
    _controller!.addListener(() {
      // print(_heightFactor!.value);
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
          ),
          _buildInfo(),
          _buildDes()
        ],
      ),
    );
  }

  // 视频标题
  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            widget.videoModel.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          const Padding(
            padding: EdgeInsets.only(left: 15),
          ),
          Icon(
            _expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 16,
          )
        ],
      ),
    );
  }

  // 动画切换
  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        // 执行动画
        _controller!.forward();
      } else {
        // 反向执行动画
        _controller!.reverse();
      }
    });
  }

  // 观看、评论、日期
  _buildInfo() {
    var style = const TextStyle(fontSize: 12, color: Colors.grey);
    var createTime = widget.videoModel.created_at;
    var dataStr =
        createTime!.length > 10 ? createTime.substring(5, 10) : createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.videoModel.view),
        const Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        ...smallIconText(Icons.list_alt, widget.videoModel.reply),
        Text('    $dataStr', style: style)
      ],
    );
  }

  // 视频描述
  _buildDes() {
    var child = _expand
        ? Text(
            widget.videoModel.desc!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
        : null;

    // 构建动画的通用widget
    return AnimatedBuilder(
        animation: _controller!,
        child: child,
        builder: (ctx, child) {
          return Align(
            // 因为align 可以设置 heightFactor，所以上面才用_heightFactor
            heightFactor: _heightFactor!.value,
            // fix 让布局从最上面的位置开始展开
            alignment: Alignment.topCenter,
            child: Container(
              // 让内容撑满后居左，内容会撑满container的宽和高
              // 其次会将内容从左上角的开始排列
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 8),
              child: child,
            ),
          );
        });
  }
}
