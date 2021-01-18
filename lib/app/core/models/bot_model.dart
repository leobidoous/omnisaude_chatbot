class Bot {
  String id;
  String avatar;
  String name;
  String organization;

  Bot({this.id, this.avatar, this.name, this.organization});

  Bot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    organization = json['organization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['organization'] = this.organization;
    return data;
  }
}
