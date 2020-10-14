import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

class FileContentWidget extends StatefulWidget {
  final FileContent message;
  final String peer;

  const FileContentWidget(
      {Key key, @required this.message, @required this.peer})
      : super(key: key);

  @override
  _FileContentWidgetState createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: Colors.grey,
    );
  }
}
