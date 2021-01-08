import '../enums/enums.dart';

class MessageContent {
  MessageType messageType;
  String value;

  /// Component [extras] representa o atributo de resposta para uma seleção
  /// de uma lista de [Option] no modelo de [SwitchContent].
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
