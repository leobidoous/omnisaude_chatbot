import 'package:flutter/material.dart';

import '../../core/enums/enums.dart';
import '../../core/models/event_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../shared/image/image_widget.dart';

class EventContentWidget extends StatefulWidget {
  final WsMessage message;
  final WsMessage lastMessage;
  final String myPeer;

  const EventContentWidget({
    Key key,
    @required this.message,
    @required this.lastMessage,
    this.myPeer,
  }) : super(key: key);

  @override
  _EventContentWidgetState createState() => _EventContentWidgetState();
}

class _EventContentWidgetState extends State<EventContentWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.message.eventContent.eventType) {
      case EventType.SYSTEM:
        return _eventMessageWidget(widget.message.eventContent);
      case EventType.ERROR:
        return _eventMessageWidget(widget.message.eventContent);
      case EventType.TYPING:
        return _eventTypingWidget(
          widget.message.eventContent,
          widget.lastMessage.eventContent,
        );
      case EventType.CONNECTED:
        break;
      case EventType.AUTHENTICATION:
        break;
      case EventType.NLU_START:
        break;
      case EventType.NLU_END:
        break;
      case EventType.ENTRY_QUEUE:
        final EventContent _message = EventContent(
          message: "Aguardando atendimento",
        );
        return _eventMessageWidget(_message);
      case EventType.USER_LEFT:
        final EventContent _message = EventContent(
          message: "${widget.message.username} saiu da conversa",
        );
        return _eventMessageWidget(_message);
      case EventType.ATTENDANT_LEFT:
        final EventContent _message = EventContent(
          message: "${widget.message.username} saiu da conversa",
        );
        return _eventMessageWidget(_message);
      case EventType.INIT_ATTENDANCE:
        String _label = widget.message.username;
        if (widget.myPeer == widget.message.peer) _label = "Você";

        final EventContent _message = EventContent(
          message: "$_label assumiu a conversa",
        );
        return _eventMessageWidget(_message);
      case EventType.FINISH_ATTENDANCE:
        final EventContent _message = EventContent(
          message: "Atendimento finalizado",
        );
        return _eventMessageWidget(_message);
      default:
        break;
    }
    return Container();
  }

  Widget _eventMessageWidget(EventContent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).secondaryHeaderColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            margin: const EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.white),
                const SizedBox(width: 10.0),
                Container(
                  child: Text(
                    "${event.message}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventTypingWidget(EventContent event, EventContent lastEvent) {
    if (lastEvent.eventType != EventType.TYPING || lastEvent != event) {
      return Container();
    }
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
            url: widget.lastMessage.avatarUrl,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(
                          "assets/shared/typing.gif",
                          alignment: Alignment.centerLeft,
                          color: Theme.of(context).secondaryHeaderColor,
                          colorBlendMode: BlendMode.modulate,
                          package: "omnisaude_chatbot",
                          height: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
