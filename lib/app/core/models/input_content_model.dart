import '../enums/enums.dart';

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
