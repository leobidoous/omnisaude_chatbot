import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/datetime_on_message/datetime_on_message_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/event_content/event_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/file_content/file_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/message_content/message_content_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/switch_content/switch_content_widget.dart';

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
    final Color _botColor = Theme.of(context).primaryColor;
    final Color _userColor = Theme.of(context).cardColor;

    if (_message.eventContent != null) {
      return EventContentWidget(
        message: _message.eventContent,
        peer: _message.peer,
      );
    } else if (_message.fileContent != null) {
      if (_message.peer == _userPeer) {
        return _userContent(
          _message,
          FileContentWidget(message: _message, color: _userColor),
        );
      }
      return _botContent(
        _message,
        FileContentWidget(message: _message, color: _botColor),
      );
    } else if (_message.messageContent != null) {
      if (_message.peer == _userPeer) {
        return _userContent(
          _message,
          MessageContentWidget(message: _message, color: _userColor),
        );
      }
      return _botContent(
        _message,
        MessageContentWidget(message: _message, color: _botColor),
      );
    } else if (_message.switchContent != null) {
      return SwitchContentWidget(
        message: _message.switchContent,
        peer: _message.peer,
        enabled: _enabled,
      );
    }
    return Container();
  }

  Widget _userContent(WsMessage message, child) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.2,
        bottom: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                    child: child,
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(
                  dateTime: DateTime.parse(message.datetime),
                  message: message,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          AvatarWidget(
            url: message.avatarUrl,
            width: 30.0,
            height: 30.0,
            radius: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _botContent(WsMessage message, child) {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.2,
        bottom: 5.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarWidget(
            url: message.avatarUrl,
            width: 30.0,
            height: 30.0,
            radius: 10.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    child: child,
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(
                  dateTime: DateTime.parse(message.datetime),
                  message: message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
