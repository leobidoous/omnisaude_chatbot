import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/view_photo_service.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';

class MessageContentWidget extends StatefulWidget {
  final WsMessage message;
  final Color color;

  const MessageContentWidget(
      {Key key, @required this.message, @required this.color})
      : super(key: key);

  @override
  _MessageContentWidgetState createState() => _MessageContentWidgetState();
}

class _MessageContentWidgetState extends State<MessageContentWidget> {
  @override
  Widget build(BuildContext context) {
    final MessageContent _message = widget.message.messageContent;
    final Color _color = widget.color;

    switch (_message.messageType) {
      case MessageType.HTML:
        return _htmlContent(_message.value, _color);
      case MessageType.TEXT:
        return _textContent(_message.value, _color);
      case MessageType.IMAGE:
        return _imageContent(_message.value, _color);
      // default:
      //   return _textContent(_message.value, _color);
    }
    return Container();
  }

  Widget _textContent(String message, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(5.0),
      child: SelectableText(
        "$message",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _imageContent(String url, Color color) {
    return Container(
      color: color,
      constraints: BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final ViewPhotoService _viewPhotoService = ViewPhotoService();
                _viewPhotoService.onViewSinglePhoto(context, url);
                _viewPhotoService.dispose();
              },
              child: AvatarWidget(
                url: url,
                boxFit: BoxFit.cover,
                radius: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _htmlContent(String message, Color color) {
    return Container(
      color: color,
      // padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Html(data: message),
        ],
      ),
    );
  }
}
