import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:omnisaude_chatbot/app/core/models/message_content_model.dart';

import '../../components/components.dart';
import '../../connection/connection.dart';
import '../../core/enums/enums.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/datetime_picker_service.dart';
import '../switch_content/switch_content_widget.dart';
import '../upload_content/upload_content_widget.dart';
import 'panel_send_message_controller.dart';

class PanelSendMessageWidget extends StatefulWidget {
  final WsMessage message;
  final Connection connection;

  const PanelSendMessageWidget({
    Key key,
    @required this.message,
    @required this.connection,
  }) : super(key: key);

  @override
  _PanelSendMessageWidgetState createState() => _PanelSendMessageWidgetState();
}

class _PanelSendMessageWidgetState extends State<PanelSendMessageWidget> {
  final PanelSendMessageController _controller = PanelSendMessageController();
  final TextEditingController _messageText = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  TextInputType _textInputType = TextInputType.text;
  MaskTextInputFormatter _mask = MaskTextInputFormatter();

  @override
  void dispose() {
    _messageFocus.dispose();
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.message;
    final Connection _connection = widget.connection;

    _controller.panelSwitchEnabled = false;
    _controller.panelInputEnabled = false;

    _controller.attachEnabled = false;
    _controller.dateEnabled = false;
    _controller.textEnabled = false;

    if (_message.eventContent != null) {
      switch (_message.eventContent.eventType) {
        case EventType.NLU_START:
          _controller.nluEnabled = true;
          break;
        case EventType.NLU_END:
          _controller.nluEnabled = false;
          break;
        case EventType.USER_LEFT:
          _controller.humanAttendant = false;
          break;
        case EventType.ATTENDANT_LEFT:
          _controller.humanAttendant = false;
          break;
        case EventType.INIT_ATTENDANCE:
          _controller.humanAttendant = true;
          break;
        case EventType.FINISH_ATTENDANCE:
          _controller.humanAttendant = false;
          break;
        case EventType.UPDATE_QUEUE:
          _controller.humanAttendant = true;
          break;
        default:
          break;
      }
    }

    if (_message.inputContent != null) {
      _controller.panelInputEnabled = true;
      _mask = MaskTextInputFormatter(mask: _message.inputContent.mask);

      switch (_message.inputContent.inputType) {
        case InputType.DATE:
          _controller.dateEnabled = true;
          break;
        case InputType.TEXT:
          _controller.textEnabled = true;
          break;
        case InputType.NUMBER:
          _controller.textEnabled = true;
          break;
        case InputType.EMAIL:
          _controller.textEnabled = true;
          break;
      }

      switch (_message.inputContent.keyboardType) {
        case KeyboardType.DATE:
          _textInputType = TextInputType.datetime;
          break;
        case KeyboardType.EMAIL:
          _textInputType = TextInputType.emailAddress;
          break;
        case KeyboardType.NUMBER:
          _textInputType = TextInputType.number;
          break;
        case KeyboardType.TEXT:
          _textInputType = TextInputType.text;
          break;
      }
    }

    if (_message.uploadContent != null) {
      _controller.panelInputEnabled = true;
      _controller.attachEnabled = true;
    }

    if (_message.switchContent != null) {
      _controller.panelSwitchEnabled = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _panelSwitch(_connection, _message),
        _panelSendMessage(_message),
      ],
    );
  }

  Widget _panelSwitch(Connection connection, WsMessage message) {
    if (message.switchContent == null) return Container();
    return Observer(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              constraints: BoxConstraints(
                maxHeight: _controller.panelSwitchEnabled ? 250.0 : 0.0,
              ),
              curve: Curves.easeIn,
              height: _controller.panelSwitchEnabled ? null : 0.0,
              color: Theme.of(context).textTheme.headline5.color,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxHeight: 250),
                      child: SwitchContentWidget(
                        connection: connection,
                        message: message,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _panelSendMessage(WsMessage message) {
    return Observer(
      builder: (context) {
        final bool _enabled = _controller.nluEnabled ||
            _controller.panelInputEnabled ||
            _controller.humanAttendant;
        if (!_enabled) return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              constraints: BoxConstraints(maxHeight: _enabled ? 100 : 0.0),
              curve: Curves.easeIn,
              height: _enabled ? null : 0.0,
              child: Container(
                color: Theme.of(context).textTheme.headline4.color,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Observer(
                  builder: (context) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _btnChooseDateWidget(),
                        _btnChooseFileWidget(message),
                        Expanded(child: _textFormFieldWidget()),
                        _btnSendTextMessageWidget(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _btnChooseDateWidget() {
    return IgnorePointer(
      ignoring: !_controller.dateEnabled,
      child: Opacity(
        opacity: _controller.dateEnabled ? 1.0 : 0.3,
        child: IconButton(
          iconSize: 30.0,
          onPressed: () async {
            final DatetimePickerService _service = DatetimePickerService();
            await _service.onShowDateTimePicker(context).then(
              (value) async {
                if (value == null) return;
                WsMessage _message = WsMessage(
                  messageContent: MessageContent(
                    messageType: MessageType.TEXT,
                    value: DateFormat("dd/MM/yyyy", "pt_BR").format(value),
                  ),
                );
                await widget.connection.onSendMessage(_message);
              },
            ).catchError((onError) => null);
          },
          color: Theme.of(context).textTheme.headline1.color,
          icon: Icon(Icons.date_range_rounded),
        ),
      ),
    );
  }

  Widget _btnChooseFileWidget(WsMessage message) {
    final bool _enabled =
        _controller.attachEnabled || _controller.humanAttendant;

    return IgnorePointer(
      ignoring: !_enabled,
      child: Opacity(
        opacity: _enabled ? 1.0 : 0.3,
        child: UploadContentWidget(
          onSendMessage: widget.connection.onSendMessage,
          message: message,
        ),
      ),
    );
  }

  Widget _textFormFieldWidget() {
    final bool _enabled = _controller.nluEnabled ||
        _controller.textEnabled ||
        _controller.humanAttendant;
    return IgnorePointer(
      ignoring: !_enabled,
      child: Opacity(
        opacity: _enabled ? 1.0 : 0.3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).textTheme.headline5.color,
          ),
          child: TextFormField(
            minLines: 1,
            maxLines: kIsWeb ? 1 : 5,
            autofocus: true,
            focusNode: _messageFocus,
            controller: _messageText,
            enabled: _enabled,
            inputFormatters: [_mask],
            keyboardType: _textInputType,
            scrollPhysics: BouncingScrollPhysics(),
            textInputAction: TextInputAction.newline,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: TextCapitalization.sentences,
            onFieldSubmitted: (String input) => _onSendTextMessage(input),
            decoration: InputDecoration(
              hintText: "Escreva uma mensagem",
              contentPadding: EdgeInsets.all(15.0),
              border: generalOutlineInputBorder(),
              focusedBorder: generalOutlineInputBorder(),
              enabledBorder: generalOutlineInputBorder(),
              disabledBorder: generalOutlineInputBorder(),
              focusedErrorBorder: generalOutlineInputBorder(),
              errorBorder: generalOutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnSendTextMessageWidget() {
    final bool _enabled = _controller.nluEnabled ||
        _controller.textEnabled ||
        _controller.humanAttendant;
    return IgnorePointer(
      ignoring: !_enabled,
      child: Opacity(
        opacity: _enabled ? 1.0 : 0.3,
        child: IconButton(
          iconSize: 30.0,
          onPressed: () => _onSendTextMessage(_messageText.text),
          color: Theme.of(context).textTheme.headline1.color,
          icon: Icon(Icons.send_rounded),
        ),
      ),
    );
  }

  Future<void> _onSendTextMessage(String message) async {
    if (message.trim().isNotEmpty) {
      WsMessage _message = WsMessage(
        messageContent: MessageContent(
          messageType: MessageType.TEXT,
          value: message.trim(),
        ),
      );
      await widget.connection.onSendMessage(_message).whenComplete(
            () => _messageText.clear(),
          );
      _messageFocus.requestFocus();
    }
  }
}
