import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/datetime_on_message/datetime_on_message_widget.dart';

class MessageContentWidget extends StatefulWidget {
  final WsMessage message;
  final String userPeer;

  const MessageContentWidget(
      {Key key, @required this.message, @required this.userPeer})
      : super(key: key);

  @override
  _MessageContentWidgetState createState() => _MessageContentWidgetState();
}

class _MessageContentWidgetState extends State<MessageContentWidget> {
  @override
  Widget build(BuildContext context) {
    return _chooseWidgetToRender(
      widget.message.messageContent,
      widget.message.peer,
      widget.userPeer,
    );
  }

  Widget _chooseWidgetToRender(
      MessageContent message, String peerMessage, String userPeer) {
    switch (message.messageType) {
      case MessageType.HTML:
        if (peerMessage == userPeer) {
          return _userContent(message, _htmlContent);
        } else {
          return _botContent(message, _htmlContent);
        }
        break;
      case MessageType.TEXT:
        if (peerMessage == userPeer) {
          return _userContent(message, _textContent);
        } else {
          return _botContent(message, _textContent);
        }
        break;
      case MessageType.IMAGE:
        if (peerMessage == userPeer) {
          return _userContent(message, _imageContent);
        } else {
          return _botContent(message, _imageContent);
        }
        break;
    }
    return Container();
  }

  Widget _userContent(MessageContent message, Function(String, Color) child) {
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
                    child: child(message.value, Theme.of(context).cardColor),
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(
                  dateTime: DateTime.parse(widget.message.datetime),
                  message: widget.message,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          AvatarWidget(
            url: widget.message.avatarUrl,
            width: 30.0,
            height: 30.0,
            radius: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _botContent(MessageContent message, Function(String, Color) child) {
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
          const AvatarWidget(
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
                    child: child(
                      message.value,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(
                  dateTime: DateTime.parse(widget.message.datetime),
                  message: widget.message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textContent(String message, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(5.0),
      child: SelectableText(
        "$message",
        style: TextStyle(color: Color(0xFFEEEEEE)),
      ),
    );
  }

  Widget _imageContent(String message, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(5.0),
      child: SelectableText(
        "$message",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _htmlContent(String message, Color color) {
    return Container(
      color: color,
      padding: EdgeInsets.all(5.0),
      child: SelectableText(
        "$message",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
