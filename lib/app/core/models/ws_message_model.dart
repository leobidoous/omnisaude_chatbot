import 'package:omnisaude_chatbot/app/core/enums/enums.dart';

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

  WsMessage(
      {this.datetime,
      this.peer,
      this.avatarUrl,
      this.username,
      this.inputContent,
      this.uploadContent,
      this.switchContent,
      this.messageContent,
      this.fileContent,
      this.eventContent});

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

class InputContent {
  InputType inputType;
  KeyboardType keyboardType;
  String mask;

  InputContent({this.inputType, this.keyboardType, this.mask});

  InputContent.fromJson(Map<String, dynamic> json) {
    inputType = inputTypeValues.map[json["inputType"]];
    keyboardType = keyboardTypeValues.map[json["keyboardType"]];
    mask = json['mask'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inputType'] = inputTypeValues.reverse[this.inputType];
    data['keyboardType'] = keyboardTypeValues.reverse[this.keyboardType];
    data['mask'] = this.mask;
    return data;
  }
}

class UploadContent {
  ContentFileType fileType;
  List<String> customScope;

  UploadContent({this.fileType, this.customScope});

  UploadContent.fromJson(Map<String, dynamic> json) {
    fileType = contentFileTypeValues.map[json["fileType"]];
    customScope = json['customScope'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileType'] = contentFileTypeValues.reverse[this.fileType];
    data['customScope'] = this.customScope;
    return data;
  }
}

class SwitchContent {
  String switchType;
  String componentId;
  Layout layout;
  List<Options> options;

  SwitchContent({this.switchType, this.componentId, this.layout, this.options});

  SwitchContent.fromJson(Map<String, dynamic> json) {
    switchType = json['switchType'];
    componentId = json['componentId'];
    layout = layoutValues.map[json["layout"]];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['switchType'] = this.switchType;
    data['componentId'] = this.componentId;
    data['layout'] = layoutValues.reverse[this.layout];
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String id;
  String title;
  String subtitle;
  String image;
  String value;

  Options({this.id, this.title, this.subtitle, this.image, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['image'] = this.image;
    data['value'] = this.value;
    return data;
  }
}

class MessageContent {
  MessageType messageType;
  String value;

  /// Component [extras] representa o atributo de resposta para uma seleção
  /// de uma [Options] no modelo de [SwitchContent].
  Map<String, dynamic> extras;

  MessageContent({this.messageType, this.value, this.extras});

  MessageContent.fromJson(Map<String, dynamic> json) {
    messageType = messageTypeValues.map[json["messageType"]];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageType'] = messageTypeValues.reverse[this.messageType];
    data['value'] = this.value;
    data['extras'] = this.extras;
    return data;
  }
}

class FileContent {
  ContentFileType fileType;
  String name;
  String value;
  String comment;

  FileContent({this.fileType, this.name, this.value, this.comment});

  FileContent.fromJson(Map<String, dynamic> json) {
    fileType = contentFileTypeValues.map[json["fileType"]];
    name = json['name'];
    value = json['value'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileType'] = contentFileTypeValues.reverse[this.fileType];
    data['name'] = this.name;
    data['value'] = this.value;
    data['comment'] = this.comment;
    return data;
  }
}

class EventContent {
  String message;
  String imageUrl;
  EventType eventType;

  EventContent({this.message, this.imageUrl, this.eventType});

  EventContent.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    imageUrl = json['imageUrl'];
    eventType = eventTypeValues.map[json["eventType"]];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['imageUrl'] = this.imageUrl;
    data['eventType'] = eventTypeValues.reverse[this.eventType];
    return data;
  }
}
