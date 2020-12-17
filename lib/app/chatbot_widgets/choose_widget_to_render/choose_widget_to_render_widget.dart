import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/datetime_on_message/datetime_on_message_widget.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/event_content/event_content_widget.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/file_content/file_content_widget.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/message_content/message_content_widget.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/shared_widgets/avatar/avatar_widget.dart';

class ChooseWidgetToRenderWidget extends StatefulWidget {
  final bool enabled;
  final WsMessage message;
  final Connection connection;

  const ChooseWidgetToRenderWidget(
      {Key key,
      @required this.message,
      @required this.connection,
      @required this.enabled})
      : super(key: key);

  @override
  _ChooseWidgetToRenderWidgetState createState() =>
      _ChooseWidgetToRenderWidgetState();
}

class _ChooseWidgetToRenderWidgetState
    extends State<ChooseWidgetToRenderWidget> {
  @override
  Widget build(BuildContext context) {
    final bool _enabled = widget.enabled;
    final WsMessage _message = widget.message;
    final Connection _connection = widget.connection;
    final Color _userColor = Theme.of(context).primaryColor;
    final Color _botColor = Theme.of(context).cardColor;
    final String _userPeer = widget.connection.getUserPeer();

    if (_message.eventContent != null) {
      return EventContentWidget(message: _message);
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
      /**
       * Verificar se o conteúdo da mensagem é vazio,
       * assim retiro a exibição do componente
       */
      if (_message.messageContent.value.trim().isEmpty) return Container();
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
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
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
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
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
