class Result {
  String next;
  String previous;
  int count;
  int pageSize;
  int offset;
  List<ChatBot> results;

  Result(
      {this.next,
        this.previous,
        this.count,
        this.pageSize,
        this.offset,
        this.results});

  Result.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    previous = json['previous'];
    count = json['count'];
    pageSize = json['page_size'];
    offset = json['offset'];
    if (json['results'] != null) {
      results = new List<ChatBot>();
      json['results'].forEach((v) {
        results.add(new ChatBot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    data['previous'] = this.previous;
    data['count'] = this.count;
    data['page_size'] = this.pageSize;
    data['offset'] = this.offset;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatBot {
  String id;
  String name;
  String description;
  String avatar;

  ChatBot({this.id, this.name, this.description, this.avatar});

  ChatBot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['avatar'] = this.avatar;
    return data;
  }
}