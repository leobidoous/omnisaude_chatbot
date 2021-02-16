import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/event_content_model.dart';

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

class _ChooseWidgetToRenderWidgetState extends State<ChooseWidgetToRenderWidget>
    with AutomaticKeepAliveClientMixin {
  double _height;

  @override
  void initState() {
    if (widget.message.messageContent?.value != null) {
      if (widget.message.messageContent.value.trim().length > 500) {
        _height = 200;
      }
    }
    super.initState();
  }

  @override
  bool get wantKeepAlive {
    if (widget.message.messageContent?.value != null) {
      if (widget.message.messageContent.value.trim().length > 500) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        return GestureDetector(
          onLongPress: () => _copyToClipboard(_message.messageContent.value),
          child: _myMessageWidget(
            _message,
            MessageContentWidget(
              message: _message,
              connection: widget.connection,
            ),
          ),
        );
      }
      return GestureDetector(
        onLongPress: () => _copyToClipboard(_message.messageContent.value),
        child: _anotherMessageWidget(
          _message,
          MessageContentWidget(
            message: _message,
            connection: widget.connection,
          ),
        ),
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
                      child: Stack(
                        children: [
                          Container(
                            height: _height,
                            child: child,
                          ),
                          _showMoreMessage(
                            message,
                            Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
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
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Stack(
                        children: [
                          Container(height: _height, child: child),
                          _showMoreMessage(
                            message,
                            Theme.of(context).secondaryHeaderColor,
                          ),
                        ],
                      ),
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

  Widget _showMoreMessage(WsMessage message, Color color) {
    if (_height == null) return Column();
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: InkWell(
          onTap: () => setState(() => _height = null),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              // color: Theme.of(context).canvasColor,
              gradient: LinearGradient(
                begin: Alignment(0.0, 0.0),
                end: Alignment(0.0, 0.8),
                tileMode: TileMode.clamp,
                colors: [
                  color.withOpacity(0),
                  color.withOpacity(0.3),
                  color.withOpacity(0.35),
                  color.withOpacity(0.4),
                  color.withOpacity(0.45),
                  color.withOpacity(0.5),
                  color.withOpacity(0.55),
                  color.withOpacity(0.6),
                  color.withOpacity(0.65),
                  color.withOpacity(0.7),
                  color.withOpacity(0.75),
                  color.withOpacity(0.8),
                  color.withOpacity(0.85),
                  color.withOpacity(0.9),
                  color.withOpacity(0.95),
                  color.withOpacity(1),
                ],
              ),
            ),
            padding: const EdgeInsets.only(top: 50.0, bottom: 5.0),
            alignment: Alignment.center,
            child: Text(
              "Ver tudo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: Theme.of(context).primaryColor,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String message) {
    Clipboard.setData(ClipboardData(text: message));
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2000),
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.95),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: Text(
          "Conteúdo copiado para área de transferência!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
      ),
    );
  }
}
