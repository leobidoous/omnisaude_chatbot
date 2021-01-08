class User {
  String name;
  String avatar;
  String entered;
  String peer;
  String session;

  User({this.name, this.avatar, this.entered, this.peer, this.session});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    entered = json['entered'];
    peer = json['peer'];
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['entered'] = this.entered;
    data['peer'] = this.peer;
    data['session'] = this.session;
    return data;
  }
}