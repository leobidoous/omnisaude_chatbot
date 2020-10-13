import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

class EventContentWidget extends StatefulWidget {
  final EventContent message;
  final String peer;

  const EventContentWidget(
      {Key key, @required this.message, @required this.peer})
      : super(key: key);

  @override
  _EventContentWidgetState createState() => _EventContentWidgetState();
}

class _EventContentWidgetState extends State<EventContentWidget> {
  @override
  Widget build(BuildContext context) {
    return _chooseWidgetToRender(widget.message);
  }

  Widget _chooseWidgetToRender(EventContent message) {
    switch (message.eventType) {
      case EventType.DEBUG:
        return _systemContent(message);
      case EventType.ERROR:
        return _systemContent(message);
      case EventType.HUMAN_ATTENDANCE:
        return _systemContent(message);
      case EventType.SYSTEM:
        return _systemContent(message);
      default:
        break;
    }
    return Container();
  }

  Widget _systemContent(EventContent message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade50,
          ),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          margin: EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline_rounded),
              SizedBox(width: 10.0),
              Container(child: Text("${message.message}")),
            ],
          ),
        ),
      ],
    );
  }
}
