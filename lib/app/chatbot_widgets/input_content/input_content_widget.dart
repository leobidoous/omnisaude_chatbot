import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/shared_widgets/avatar/avatar_widget.dart';

import 'input_content_controller.dart';

class InputContentWidget extends StatefulWidget {
  final Future<void> Function(WsMessage) onSendMessage;
  final InputContent message;
  final String peer;

  final DateTime firstDate;
  final DateTime initialDate;
  final DateTime lastDate;
  final bool enabled;

  const InputContentWidget(
      {Key key,
      @required this.onSendMessage,
      @required this.message,
      @required this.peer,
      @required this.firstDate,
      @required this.initialDate,
      @required this.lastDate,
      @required this.enabled})
      : super(key: key);

  @override
  _InputContentWidgetState createState() => _InputContentWidgetState();
}

class _InputContentWidgetState
    extends ModularState<InputContentWidget, InputContentController> {
  final TextEditingController _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: _widget(),
    );
  }

  Widget _widget() {
    return Row(
      children: [
        AvatarWidget(width: 30.0, height: 30.0),
        SizedBox(width: 10.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: FlatButton(
            onPressed: () async => await _onSelectDateTime(),
            color:
                widget.enabled ? Colors.white : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            child: Text(
              "Informe a data",
              style: TextStyle(
                color: widget.enabled ? Theme.of(context).primaryColor : null,
              ),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        FlatButton(
          onPressed: () async => await _onSelectDateTime(),
          color: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(
            Icons.date_range_outlined,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _iconButtonContent(
      Function onPressed, Color color, IconData iconData) {
    return IconButton(
      onPressed: onPressed,
      color: color,
      icon: Icon(iconData),
      padding: EdgeInsets.zero,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _onDateTimeTextContent() {
    final Function _cancel = () => Navigator.pop(context);

    return Row(
      children: [
        Flexible(
          child: CupertinoTextField(
            readOnly: true,
            controller: _message,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.send,
            textCapitalization: TextCapitalization.sentences,
            placeholder: "Ex: 01/01/2000",
          ),
        ),
        _iconButtonContent(_cancel, Colors.red, Icons.clear),
        Observer(
          builder: (BuildContext context) {
            Function _confirm;
            if (controller.dateTimeSelected != null) {
              _confirm = () {
                String _date = DateFormat(
                  "dd/MM/yyyy",
                  "pt_BR",
                ).format(controller.dateTimeSelected);
                _cancel();
              };
            } else {
              _confirm = null;
            }
            return _iconButtonContent(
              _confirm,
              Theme.of(context).primaryColor,
              Icons.done_rounded,
            );
          },
        ),
      ],
    );
  }

  Future<void> _onSelectDateTime() async {
    if (kIsWeb) {
      return await _onShowDateTimeDialog();
    }
  }

  Future<void> _onShowDateTimeDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                color: Theme.of(context).backgroundColor,
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 0.0,
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: CalendarDatePicker(
                          onDateChanged: (DateTime dateTime) {
                            controller.dateTimeSelected = dateTime;
                            _message.text = DateFormat(
                              "EEEE, dd MMMM yyyy",
                              "pt_BR",
                            ).format(dateTime);
                          },
                          firstDate: widget.firstDate,
                          initialDate: widget.initialDate,
                          lastDate: widget.lastDate,
                        ),
                      ),
                      _onDateTimeTextContent(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
