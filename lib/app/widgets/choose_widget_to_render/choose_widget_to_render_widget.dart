import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/widgets/event_content/event_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/file_content/file_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/input_content/input_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/message_content/message_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/switch_content/switch_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/upload_content/upload_content_widget.dart';

class ChooseWidgetToRenderWidget extends StatefulWidget {
  final WsMessage message;
  final String userPeer;
  final bool isLastMessage;

  const ChooseWidgetToRenderWidget(
      {Key key,
      @required this.message,
      @required this.userPeer,
      @required this.isLastMessage})
      : super(key: key);

  @override
  _ChooseWidgetToRenderWidgetState createState() =>
      _ChooseWidgetToRenderWidgetState();
}

class _ChooseWidgetToRenderWidgetState
    extends State<ChooseWidgetToRenderWidget> {
  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.message;
    final String _userPeer = widget.userPeer;
    final bool _enabled = widget.isLastMessage;

    if (_message.eventContent != null) {
      return EventContentWidget(
        message: _message.eventContent,
        peer: _message.peer,
      );
    } else if (_message.fileContent != null) {
      return FileContentWidget(
        message: _message.fileContent,
        peer: _message.peer,
      );
    } else if (_message.inputContent != null) {
      if (_message.inputContent.inputType == InputType.TEXT) {
        return Container();
      }
      final DateTime _now = DateTime.now();
      return InputContentWidget(
        message: _message.inputContent,
        peer: _message.peer,
        enabled: _enabled,
        initialDate: _now,
        firstDate: DateTime(_now.year - 1),
        lastDate: DateTime(_now.year + 1),
      );
    } else if (_message.messageContent != null) {
      return MessageContentWidget(
        message: _message,
        userPeer: _userPeer,
      );
    } else if (_message.switchContent != null) {
      return SwitchContentWidget(
        message: _message.switchContent,
        peer: _message.peer,
        enabled: _enabled,
      );
    } else if (_message.uploadContent != null) {
      return UploadContentWidget(
        message: _message,
        peer: _message.peer,
        enabled: _enabled,
      );
    }
    return Container();
  }
}
