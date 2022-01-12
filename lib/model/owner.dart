class Owner {
  String? name;
  String? face;
  int? fans;

  Owner({
    this.name,
    this.face,
    this.fans,
  });

  // map类型的json
  // {
  //     "name": 'xxx',
  //     "face": 'faceface',
  //     "fans": 20
  //   }
  // map => mo
  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
  }

  // mo => map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    return data;
  }
}
