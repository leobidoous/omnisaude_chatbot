import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

class SwitchContentWidget extends StatefulWidget {
  final SwitchContent message;
  final String peer;
  final bool enabled;

  const SwitchContentWidget(
      {Key key,
      @required this.message,
      @required this.peer,
      @required this.enabled})
      : super(key: key);

  @override
  _SwitchContentWidgetState createState() => _SwitchContentWidgetState();
}

class _SwitchContentWidgetState extends State<SwitchContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
