import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

class EventContentWidget extends StatefulWidget {
  final WsMessage message;

  const EventContentWidget({Key key, @required this.message}) : super(key: key);

  @override
  _EventContentWidgetState createState() => _EventContentWidgetState();
}

class _EventContentWidgetState extends State<EventContentWidget> {
  @override
  Widget build(BuildContext context) {
    final EventContent _event = widget.message.eventContent;

    switch (_event.eventType) {
      case EventType.DEBUG:
        return _systemContent(_event);
      case EventType.ERROR:
        return _systemContent(_event);
      case EventType.SYSTEM:
        return _systemContent(_event);

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
        return _systemContent(_message);
      case EventType.USER_LEFT:
        final EventContent _message = EventContent(
          message: "${widget.message.username} saiu da conversa",
        );
        return _systemContent(_message);
      case EventType.ATTENDANT_LEFT:
        final EventContent _message = EventContent(
          message: "${widget.message.username} saiu da conversa",
        );
        return _systemContent(_message);
      case EventType.INIT_ATTENDANCE:
        final EventContent _message = EventContent(
          message: "${widget.message.username} assumiu a conversa",
        );
        return _systemContent(_message);
      case EventType.FINISH_ATTENDANCE:
        final EventContent _message = EventContent(
          message: "Atendimento finalizado",
        );
        return _systemContent(_message);
      default:
        break;
    }
    return Container();
  }

  Widget _systemContent(EventContent message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).cardColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            margin: EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.white),
                SizedBox(width: 10.0),
                Container(
                    child: Text(
                  "${message.message}",
                  style: TextStyle(color: Colors.white),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
