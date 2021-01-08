import 'event_content_model.dart';
import 'file_content_model.dart';
import 'input_content_model.dart';
import 'message_content_model.dart';
import 'switch_content_model.dart';
import 'upload_content_model.dart';

class WsMessage {
  String datetime;
  String peer;
  String avatarUrl;
  String username;
  InputContent inputContent;
  UploadContent uploadContent;
  SwitchContent switchContent;
  MessageContent messageContent;
  FileContent fileContent;
  EventContent eventContent;

  WsMessage({
    this.datetime,
    this.peer,
    this.avatarUrl,
    this.username,
    this.inputContent,
    this.uploadContent,
    this.switchContent,
    this.messageContent,
    this.fileContent,
    this.eventContent,
  });

  WsMessage.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    peer = json['peer'];
    avatarUrl = json['avatarUrl'];
    username = json['username'];
    inputContent =
        json['input'] != null ? new InputContent.fromJson(json['input']) : null;
    uploadContent = json['upload'] != null
        ? new UploadContent.fromJson(json['upload'])
        : null;
    switchContent = json['switch'] != null
        ? new SwitchContent.fromJson(json['switch'])
        : null;
    messageContent = json['message'] != null
        ? new MessageContent.fromJson(json['message'])
        : null;
    fileContent =
        json['file'] != null ? new FileContent.fromJson(json['file']) : null;
    eventContent =
        json['event'] != null ? new EventContent.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['peer'] = this.peer;
    data['avatarUrl'] = this.avatarUrl;
    data['username'] = this.username;
    if (this.inputContent != null) {
      data['input'] = this.inputContent.toJson();
    }
    if (this.uploadContent != null) {
      data['upload'] = this.uploadContent.toJson();
    }
    if (this.switchContent != null) {
      data['switch'] = this.switchContent.toJson();
    }
    if (this.messageContent != null) {
      data['message'] = this.messageContent.toJson();
    }
    if (this.fileContent != null) {
      data['file'] = this.fileContent.toJson();
    }
    if (this.eventContent != null) {
      data['event'] = this.eventContent.toJson();
    }
    return data;
  }
}
