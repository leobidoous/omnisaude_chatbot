import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  SlidableController _slidableController = new SlidableController();

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
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          controller: _slidableController,
          enabled: widget.connection.showingPanel,
          actionExtentRatio: 0.15,
          key: ObjectKey(_message),
          // actions: <Widget>[
          //   IconSlideAction(
          //     color: Colors.transparent,
          //     iconWidget: Icon(
          //       Icons.reply_rounded,
          //       color: Theme.of(context).primaryColor,
          //     ),
          //   ),
          // ],
          secondaryActions: <Widget>[
            IconSlideAction(
              color: Colors.transparent,
              iconWidget: Icon(
                Icons.more_horiz_rounded,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () async => await showMoreOptions(_message),
            ),
          ],
          child: _myMessageWidget(
            _message,
            MessageContentWidget(
              message: _message,
              connection: widget.connection,
            ),
          ),
        );
      }
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        controller: _slidableController,
        enabled: widget.connection.showingPanel,
        actionExtentRatio: 0.15,
        movementDuration: Duration(milliseconds: 100),
        key: ObjectKey(_message),
        // actions: <Widget>[
        //   IconSlideAction(
        //     color: Colors.transparent,
        //     iconWidget: Icon(
        //       Icons.reply_rounded,
        //       color: Theme.of(context).primaryColor,
        //     ),
        //   ),
        // ],
        secondaryActions: <Widget>[
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Icon(
              Icons.more_horiz_rounded,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () async => await showMoreOptions(_message),
          ),
        ],
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
                      color: Theme.of(context).secondaryHeaderColor,
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

  Future<void> showMoreOptions(WsMessage message) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).cardColor,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: message.messageContent.value),
                    );
                    Navigator.pop(_);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 2000),
                        backgroundColor:
                            Theme.of(context).backgroundColor.withOpacity(0.95),
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
                  },
                  title: Text(
                    "Copiar",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  leading: Icon(
                    Icons.copy_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // Divider(height: 0.0),
                // ListTile(
                //   onTap: null,
                //   title: Text(
                //     "Apagar mensagem",
                //     style: TextStyle(
                //       color:
                //           Theme.of(context).textTheme.bodyText1.color,
                //     ),
                //   ),
                //   leading: Icon(
                //     Icons.delete_rounded,
                //     color: Theme.of(context).primaryColor,
                //   ),
                // ),
                Divider(height: 0.0),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textColor: Colors.white,
                    child: Text("Cancelar"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
