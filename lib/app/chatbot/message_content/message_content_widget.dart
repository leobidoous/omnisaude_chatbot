import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:omnisaude_chatbot/app/connection/chat_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/message_content_model.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/view_photo_service.dart';
import 'package:omnisaude_chatbot/app/shared/image/image_widget.dart';

class MessageContentWidget extends StatefulWidget {
  final WsMessage message;
  final ChatConnection connection;

  const MessageContentWidget(
      {Key key, @required this.message, @required this.connection})
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
        return _htmlWidget(_message.value);
      case MessageType.TEXT:
        return _textWidget(_message.value);
      case MessageType.IMAGE:
        return _imageWidget(_message.value);
    }
    return Container();
  }

  Widget _textWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        "${message.trim()}",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _imageWidget(String url) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      padding: const EdgeInsets.all(2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final ViewPhotoService _viewPhotoService = ViewPhotoService();
                await _viewPhotoService.onViewSinglePhoto(context, url);
                _viewPhotoService.dispose();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.headline4.color,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ImageWidget(url: url, radius: 20.0, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _htmlWidget(String message) {
    return Html(
      data: message,
      shrinkWrap: true,
      style: {
        "html": Style(
          color: Colors.white,
          margin: EdgeInsets.zero,
          whiteSpace: WhiteSpace.PRE,
          padding: const EdgeInsets.all(10.0),
        ),
        "body": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          whiteSpace: WhiteSpace.PRE,
        ),
      },
      customRender: {
        "img": (RenderContext renderContext, Widget child, attributes, _) {
          try {
            final Uint8List _bytes = base64Decode(
              attributes["src"].split("base64,").last,
            );

            double _width;
            double _height;
            if (attributes["width"] != null) {
              _width = double.tryParse(
                attributes["width"].replaceAll("px", ""),
              );
            }
            if (attributes["height"] != null) {
              _height = double.tryParse(
                attributes["height"].replaceAll("px", ""),
              );
            }
            return Container(
              color: Theme.of(context).secondaryHeaderColor,
              child: Center(
                child: Image.memory(_bytes, width: _width, height: _height),
              ),
            );
          } catch (e) {
            return child;
          }
        }
      },
      onLinkTap: (url) async {
        await launch(url, forceWebView: true, enableJavaScript: true);
      },
      onImageTap: (src) {
        print(src);
      },
      onImageError: (exception, stackTrace) {
        print(exception);
      },
    );
  }

  RelativeRect buttonMenuPosition(BuildContext c) {
    final RenderBox _obj = c.findRenderObject();
    final RenderBox overlay = Overlay.of(c).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        _obj.localToGlobal(_obj.size.bottomLeft(Offset.zero),
            ancestor: overlay),
        _obj.localToGlobal(_obj.size.bottomLeft(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }
}
