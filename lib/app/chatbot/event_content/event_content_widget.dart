import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/event_content_model.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

class EventContentWidget extends StatefulWidget {
  final WsMessage message;
  final String myPeer;

  const EventContentWidget({
    Key key,
    @required this.message,
    this.myPeer,
  }) : super(key: key);

  @override
  _EventContentWidgetState createState() => _EventContentWidgetState();
}

class _EventContentWidgetState extends State<EventContentWidget> {
  @override
  Widget build(BuildContext context) {
    final EventContent _event = widget.message.eventContent;

    switch (_event.eventType) {
      case EventType.SYSTEM:
        return _eventMessageWidget(_event);
      case EventType.ERROR:
        return _eventMessageWidget(_event);

      case EventType.TYPING:
        // TODO: Handle this case.
        break;
      case EventType.CONNECTED:
        // TODO: Handle this case.
        break;
      case EventType.NLU_START:
        // TODO: Handle this case.
        break;
      case EventType.NLU_END:
        // TODO: Handle this case.
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

  Widget _eventMessageWidget(EventContent message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).cardColor,
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
                    "${message.message}",
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

}
