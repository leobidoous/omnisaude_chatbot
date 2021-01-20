import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/models/event_content_model.dart';

import '../../connection/chat_connection.dart';
import '../../core/models/ws_message_model.dart';
import '../../shared/image/image_widget.dart';
import '../datetime_on_message/datetime_on_message_widget.dart';
import '../event_content/event_content_widget.dart';
import '../file_content/file_content_widget.dart';
import '../message_content/message_content_widget.dart';

class ChooseWidgetToRenderWidget extends StatefulWidget {
  final WsMessage message;
  final WsMessage lastMessage;
  final ChatConnection connection;

  const ChooseWidgetToRenderWidget({
    Key key,
    @required this.message,
    @required this.lastMessage,
    @required this.connection,
  }) : super(key: key);

  @override
  _ChooseWidgetToRenderWidgetState createState() =>
      _ChooseWidgetToRenderWidgetState();
}

class _ChooseWidgetToRenderWidgetState
    extends State<ChooseWidgetToRenderWidget> {
  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.message;
    final WsMessage _lastMessage = widget.lastMessage;
    final String _myPeer = widget.connection.getUserPeer;

    // Se o objeto for um evento
    if (_message.eventContent != null) {
      WsMessage _aux = WsMessage(eventContent: EventContent());
      if (_lastMessage.eventContent != null) _aux = _lastMessage;
      return EventContentWidget(
        message: _message,
        lastMessage: _aux,
        myPeer: _myPeer,
      );
    }

    // Se o objeto for um arquivo
    if (_message.fileContent != null) {
      if (_message.peer == _myPeer) {
        return _myMessageWidget(_message, FileContentWidget(message: _message));
      }
      return _anotherMessageWidget(
          _message, FileContentWidget(message: _message));
    }

    // Se o objeto for uma mensagem
    if (_message.messageContent != null) {
      if (_message.messageContent.value == null) return Container();
      if (_message.messageContent.value.trim().isEmpty) return Container();
      if (_message.peer == _myPeer) {
        return _myMessageWidget(
          _message,
          MessageContentWidget(message: _message),
        );
      }
      return _anotherMessageWidget(
        _message,
        MessageContentWidget(message: _message),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min);
  }

  Widget _myMessageWidget(WsMessage message, child) {
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: child,
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(message: message),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          ImageWidget(
            url: message.avatarUrl,
            asset: "assets/avatar/user.png",
            fit: BoxFit.cover,
            width: 30.0,
            height: 30.0,
            radius: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _anotherMessageWidget(WsMessage message, child) {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.2,
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(
            url: message.avatarUrl,
            asset: "assets/avatar/bot.png",
            fit: BoxFit.cover,
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: child,
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(message: message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
