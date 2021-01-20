import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../connection/chat_connection.dart';
import '../../core/enums/enums.dart';
import '../../core/models/message_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/datetime_picker_service.dart';
import '../../shared/widgets/outline_input_border.dart';
import '../switch_content/switch_content_widget.dart';
import '../upload_content/upload_content_widget.dart';

class PanelSendMessageWidget extends StatefulWidget {
  final WsMessage lastMessage;
  final ChatConnection connection;
  final bool safeArea;

  const PanelSendMessageWidget({
    Key key,
    @required this.lastMessage,
    @required this.connection,
    this.safeArea: true,
  }) : super(key: key);

  @override
  _PanelSendMessageWidgetState createState() => _PanelSendMessageWidgetState();
}

class _PanelSendMessageWidgetState extends State<PanelSendMessageWidget> {
  final TextEditingController _messageText = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  TextInputType _textInputType = TextInputType.text;
  MaskTextInputFormatter _mask = MaskTextInputFormatter();
  TextCapitalization _textCapitalization = TextCapitalization.sentences;

  bool _panelInputEnabled;
  bool _panelSwitchEnabled;
  bool _attachEnabled = false;
  bool _dateEnabled = false;
  bool _textEnabled = false;
  bool _nluEnabled = false;
  bool _humanAttendant = false;

  @override
  void dispose() {
    _messageFocus.dispose();
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.lastMessage;
    final ChatConnection _connection = widget.connection;

    _panelSwitchEnabled = false;
    _panelInputEnabled = false;

    _attachEnabled = false;
    _dateEnabled = false;
    _textEnabled = false;

    if (_message.eventContent != null) {
      switch (_message.eventContent.eventType) {
        case EventType.NLU_START:
          _nluEnabled = true;
          break;
        case EventType.NLU_END:
          _nluEnabled = false;
          break;
        case EventType.USER_LEFT:
          _humanAttendant = false;
          break;
        case EventType.ATTENDANT_LEFT:
          _humanAttendant = false;
          break;
        case EventType.INIT_ATTENDANCE:
          _humanAttendant = true;
          break;
        case EventType.FINISH_ATTENDANCE:
          _humanAttendant = false;
          break;
        case EventType.UPDATE_QUEUE:
          _humanAttendant = false;
          break;
        default:
          break;
      }
    }

    if (_message.inputContent != null) {
      _panelInputEnabled = true;
      _mask = MaskTextInputFormatter(mask: _message.inputContent.mask);
      _textCapitalization = TextCapitalization.sentences;

      switch (_message.inputContent.inputType) {
        case InputType.DATE:
          _dateEnabled = true;
          _textEnabled = true;
          _mask = MaskTextInputFormatter(mask: "##/##/####");
          break;
        case InputType.TEXT:
          _textEnabled = true;
          break;
        case InputType.NUMBER:
          _textEnabled = true;
          break;
        case InputType.EMAIL:
          _textEnabled = true;
          _textCapitalization = TextCapitalization.none;
          break;
      }

      switch (_message.inputContent.keyboardType) {
        case KeyboardType.DATE:
          _textInputType = TextInputType.number;
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
      _panelInputEnabled = true;
      _attachEnabled = true;
    }

    if (_message.switchContent != null) {
      _panelSwitchEnabled = true;
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

  Widget _panelSwitch(ChatConnection connection, WsMessage message) {
    if (message.switchContent == null) return Container();
    return SafeArea(
      bottom: widget.safeArea,
      top: widget.safeArea,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            constraints: BoxConstraints(
              maxHeight: _panelSwitchEnabled ? 250.0 : 0.0,
            ),
            curve: Curves.easeIn,
            height: _panelSwitchEnabled ? null : 0.0,
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
      ),
    );
  }

  Widget _panelSendMessage(WsMessage message) {
    final bool _enabled = _nluEnabled || _panelInputEnabled || _humanAttendant;
    if (!_enabled) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Theme.of(context).textTheme.headline4.color,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: SafeArea(
            bottom: widget.safeArea,
            top: widget.safeArea,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _btnChooseDateWidget(),
                _btnChooseFileWidget(message),
                Expanded(child: _textFormFieldWidget()),
                _btnSendTextMessageWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _btnChooseDateWidget() {
    return IgnorePointer(
      ignoring: !_dateEnabled,
      child: Opacity(
        opacity: _dateEnabled ? 1.0 : 0.3,
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
    final bool _enabled = _attachEnabled || _humanAttendant;

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
    final bool _enabled = _nluEnabled || _textEnabled || _humanAttendant;
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
            maxLines: 5,
            autofocus: true,
            enabled: _enabled,
            focusNode: _messageFocus,
            controller: _messageText,
            inputFormatters: [_mask],
            keyboardType: _textInputType,
            scrollPhysics: BouncingScrollPhysics(),
            textInputAction: TextInputAction.send,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: _textCapitalization,
            onFieldSubmitted: (String input) => _onSendTextMessage(input),
            decoration: InputDecoration(
              hintText: "Escreva uma mensagem",
              contentPadding: EdgeInsets.all(15.0),
              border: outlineInputBorder(),
              focusedBorder: outlineInputBorder(),
              enabledBorder: outlineInputBorder(),
              disabledBorder: outlineInputBorder(),
              focusedErrorBorder: outlineInputBorder(),
              errorBorder: outlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnSendTextMessageWidget() {
    final bool _enabled = _nluEnabled || _textEnabled || _humanAttendant;
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
