import '../enums/enums.dart';

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
