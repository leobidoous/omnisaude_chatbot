import '../enums/enums.dart';

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
