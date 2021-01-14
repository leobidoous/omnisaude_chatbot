import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/enums/enums.dart';
import '../../core/models/message_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/view_photo_service.dart';
import '../../shared/image/image_widget.dart';

class MessageContentWidget extends StatefulWidget {
  final WsMessage message;

  const MessageContentWidget({Key key, @required this.message})
      : super(key: key);

  @override
  _MessageContentWidgetState createState() => _MessageContentWidgetState();
}

class _MessageContentWidgetState extends State<MessageContentWidget> {
  @override
  Widget build(BuildContext context) {
    final MessageContent _message = widget.message.messageContent;

    switch (_message.messageType) {
      case MessageType.HTML:
        return _htmlContent(_message.value);
      case MessageType.TEXT:
        return _textContent(_message.value);
      case MessageType.IMAGE:
        return _imageContent(_message.value);
    }
    return Container();
  }

  Widget _textContent(String message) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: SelectableText(
        "${message?.trim()}",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _imageContent(String url) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      padding: const EdgeInsets.all(10.0),
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
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.headline4.color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ImageWidget(
                  url: url,
                  radius: 10.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _htmlContent(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Html(
          data: message,
          shrinkWrap: true,
          style: {
            "html": Style(
              color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              margin: EdgeInsets.zero,
              whiteSpace: WhiteSpace.PRE,
            ),
            "body": Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              whiteSpace: WhiteSpace.PRE,
            ),
          },
          onLinkTap: (url) async {
            await launch(
              url,
              forceWebView: true,
              enableJavaScript: true,
            );
          },
          onImageTap: (src) {
            print(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        ),
      ],
    );
  }
}
