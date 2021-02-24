import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

import '../../core/models/ws_message_model.dart';

class DatetimeOnMessageWidget extends StatefulWidget {
  final WsMessage message;

  const DatetimeOnMessageWidget({Key key, @required this.message})
      : super(key: key);

  @override
  _DatetimeOnMessageWidgetState createState() =>
      _DatetimeOnMessageWidgetState();
}

class _DatetimeOnMessageWidgetState extends State<DatetimeOnMessageWidget> {
  @override
  Widget build(BuildContext context) {
    final String _time = DateFormat("jm", "PT_br").format(
      DateTime.parse(widget.message.datetime).toLocal(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$_time",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: AppColors.textColor,
            fontSize: 10.0,
          ),
        ),
        const SizedBox(height: 1.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: AppColors.primary,
          ),
          height: 2.0,
          width: 25.0,
        ),
      ],
    );
  }
}
