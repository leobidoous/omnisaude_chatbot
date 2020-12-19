import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/view_photo_service.dart';
import 'package:omnisaude_chatbot/app/shared_widgets/avatar/avatar_widget.dart';
import 'package:universal_html/prefer_sdk/html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MessageContentWidget extends StatefulWidget {
  final WsMessage message;

  const MessageContentWidget(
      {Key key, @required this.message})
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
                  borderRadius: BorderRadius.circular(2.5),
                ),
                child: AvatarWidget(
                  url: url,
                  radius: 10.0,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _htmlContent(String message) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Html(
            data: message,
            shrinkWrap: true,
            navigationDelegateForIframe: (NavigationRequest request) async {
              print(request);
              return NavigationDecision.navigate;
            },
            style: {"html": Style(color: Colors.white)},
            customRender: {
              "div": (RenderContext context, Widget child, attributes, _) {
                if (attributes["class"] == "media-wrap embed-wrap") {
                  if (kIsWeb) {
                    return FlatButton(
                      onPressed: () async {
                        await launch(
                          _.firstChild.firstChild.attributes["src"],
                          forceWebView: true,
                          enableJavaScript: true,
                        );
                      },
                      color: Theme.of(context.buildContext).primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text("Clique aqui para visualizar o vídeo!"),
                    );
                  }
                }
                return child;
              },
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
      ),
    );
  }
}
