class HomeModel {
  List<CategoryModel>? categoryList;
  List<BannerModel>? bannerList;
  List<VideoModel>? videoList;

  HomeModel({this.categoryList, this.bannerList, this.videoList});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['categoryList'] != null) {
      categoryList = <CategoryModel>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(CategoryModel.fromJson(v));
      });
    }
    if (json['bannerList'] != null) {
      bannerList = <BannerModel>[];
      json['bannerList'].forEach((v) {
        bannerList!.add(BannerModel.fromJson(v));
      });
    }
    if (json['videoList'] != null) {
      videoList = <VideoModel>[];
      json['videoList'].forEach((v) {
        videoList!.add(VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryModel {
  int? id;
  String? name;

  CategoryModel({this.id, this.name});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class BannerModel {
  int? id;
  int? sticky;
  String? type;
  String? title;
  String? subtitle;
  String? url;
  String? cover;

  BannerModel(
      {this.id,
      this.sticky,
      this.type,
      this.title,
      this.subtitle,
      this.url,
      this.cover});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sticky = json['sticky'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];
    url = json['url'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['sticky'] = sticky;
    data['type'] = type;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['url'] = url;
    data['cover'] = cover;
    return data;
  }
}

class VideoModel {
  int? id;
  int? vid;
  String? title;
  String? tname;
  String? url;
  String? cover;
  String? desc;
  int? duration;
  int? view;
  int? pubdate;
  int? reply;
  int? favorite;
  int? like;
  int? coin;
  int? share;
  int? size;
  Owner? owner;

  VideoModel(
      {this.id,
      required this.vid,
      this.title,
      this.tname,
      this.url,
      this.cover,
      this.desc,
      this.view,
      this.pubdate,
      this.duration,
      this.reply,
      this.favorite,
      this.like,
      this.coin,
      this.share,
      this.size,
      this.owner});

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vid = json['vid'];
    title = json['title'];
    tname = json['tname'];
    url = json['url'];
    cover = json['cover'];
    desc = json['desc'];
    view = json['view'];
    pubdate = json['pubdate'];
    duration = json['duration'];
    reply = json['reply'];
    favorite = json['favorite'];
    like = json['like'];
    coin = json['coin'];
    share = json['share'];
    size = json['size'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['vid'] = vid;
    data['title'] = title;
    data['tname'] = tname;
    data['url'] = url;
    data['cover'] = cover;
    data['desc'] = desc;
    data['view'] = view;
    data['pubdate'] = pubdate;
    data['duration'] = duration;
    data['reply'] = reply;
    data['favorite'] = favorite;
    data['like'] = like;
    data['coin'] = coin;
    data['share'] = share;
    data['size'] = size;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }
}

class Owner {
  int? id;
  String? username;

  Owner({this.id, this.username});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    return data;
  }
}
