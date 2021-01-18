import '../enums/enums.dart';
import 'queue_model.dart';

class EventContent {
  String message;
  String imageUrl;
  EventType eventType;
  List<Queue> queue;

  EventContent({this.message, this.imageUrl, this.eventType, this.queue});

  EventContent.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    imageUrl = json['imageUrl'];
    eventType = eventTypeValues.map[json["eventType"]];
    if (json['queue'] != null) {
      queue = new List<Queue>.empty(growable: true);
      json['queue'].forEach((v) {
        queue.add(new Queue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['imageUrl'] = this.imageUrl;
    data['eventType'] = eventTypeValues.reverse[this.eventType];
    if (this.queue != null) {
      data['queue'] = this.queue.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
