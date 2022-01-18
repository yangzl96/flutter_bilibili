import 'package:bilibili/config/index.dart';
import 'package:bilibili/model/home_model.dart';
import 'package:bilibili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class HiBanner extends StatelessWidget {
  final List<BannerModel> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;
  HiBanner(this.bannerList, {Key? key, this.bannerHeight = 160, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    print(Config.BASE_URL);
    double right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (ctx, index) {
        return _image(bannerList[index]);
      },
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: right, bottom: 10),
          builder: DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 6)),
    );
  }

  _image(BannerModel bannerMo) {
    var bannerImg = 'http://${Config.BASE_URL}${bannerMo.cover}';
    return InkWell(
      onTap: () {
        print(bannerMo.title);
        _handleClick(bannerMo);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: Image.network(
            bannerImg,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _handleClick(BannerModel bannerMo) {
    if (bannerMo.type == 'video') {
      HiNavigator.getInstance()
          .onJumpTo(RouteStatus.detail, args: {'videoMo': VideoModel(vid: 1)});
    } else {
      print(bannerMo.url);
    }
  }
}
