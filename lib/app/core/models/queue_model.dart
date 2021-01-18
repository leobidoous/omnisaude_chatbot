import 'bot_model.dart';
import 'user_model.dart';

class Queue {
  Bot bot;
  User user;

  Queue({this.bot, this.user});

  Queue.fromJson(Map<String, dynamic> json) {
    bot = json['bot'] != null ? new Bot.fromJson(json['bot']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bot != null) {
      data['bot'] = this.bot.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
