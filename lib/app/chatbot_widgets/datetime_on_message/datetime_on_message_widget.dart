import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

import 'datetime_on_message_controller.dart';

class DatetimeOnMessageWidget extends StatefulWidget {
  final DateTime dateTime;
  final WsMessage message;

  const DatetimeOnMessageWidget(
      {Key key, @required this.dateTime, @required this.message})
      : super(key: key);

  @override
  _DatetimeOnMessageWidgetState createState() =>
      _DatetimeOnMessageWidgetState();
}

class _DatetimeOnMessageWidgetState extends State<DatetimeOnMessageWidget> {
  final DatetimeOnMessageController _controller = DatetimeOnMessageController();

  @override
  Widget build(BuildContext context) {
    final String _time = DateFormat("jm", "PT_br").format(widget.dateTime);
    if (!_controller.oShowMessageDateTimeContent(widget.message)) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$_time",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10.0),
        ),
        const SizedBox(height: 1.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Theme.of(context).primaryColor,
          ),
          height: 2.0,
          width: 25.0,
        ),
      ],
    );
  }
}
