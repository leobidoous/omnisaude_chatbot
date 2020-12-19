import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/panel_send_message/panel_send_message_controller.dart';
import 'package:omnisaude_chatbot/app/chatbot_widgets/switch_content/switch_content_widget.dart';
import 'package:omnisaude_chatbot/app/components/components.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/datetime_picker_service.dart';
import 'package:omnisaude_chatbot/app/core/services/file_picker_service.dart';

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
          _controller.textEnabled = true;
          _controller.attachEnabled = true;
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
          _controller.textEnabled = true;
          _controller.attachEnabled = true;
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
      switch (_message.inputContent.inputType) {
        case InputType.DATE:
          _controller.dateEnabled = true;
          break;
        case InputType.TEXT:
          _controller.textEnabled = true;
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
                        color: Theme.of(context).primaryColor,
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
                        _btnShowDatePickerContent(),
                        _btnSelectFileContent(message),
                        Expanded(child: _textFormFieldContent()),
                        _btnSendTextMessageContent(),
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

  Widget _btnShowDatePickerContent() {
    return IgnorePointer(
      ignoring: !_controller.dateEnabled,
      child: Opacity(
        opacity: _controller.dateEnabled ? 1.0 : 0.3,
        child: IconButton(
          iconSize: 30.0,
          onPressed: _onShowDatePicker,
          color: Theme.of(context).textTheme.headline1.color,
          icon: Icon(Icons.date_range_rounded),
        ),
      ),
    );
  }

  Widget _btnSelectFileContent(WsMessage message) {
    final bool _enabled = _controller.nluEnabled ||
        _controller.attachEnabled ||
        _controller.humanAttendant;
    return IgnorePointer(
      ignoring: !_enabled,
      child: Opacity(
        opacity: _enabled ? 1.0 : 0.3,
        child: PopupMenuButton<UploadInputType>(
          onSelected: (UploadInputType type) async {
            await _onSelectFile(type, message);
          },
          elevation: 5.0,
          offset: Offset(0.0, -175.0),
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          icon: Icon(
            Icons.attach_file_rounded,
            color: Theme.of(context).textTheme.headline1.color,
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0),
          itemBuilder: (context) => <PopupMenuEntry<UploadInputType>>[
            PopupMenuItem<UploadInputType>(
              value: UploadInputType.CAMERA,
              child: Row(
                children: [
                  Icon(Icons.camera_alt_rounded),
                  SizedBox(width: 10.0),
                  Text('Câmera'),
                ],
              ),
            ),
            PopupMenuItem<UploadInputType>(
              value: UploadInputType.GALERY,
              child: Row(
                children: [
                  Icon(Icons.photo_library_rounded),
                  SizedBox(width: 10.0),
                  Text('Galeria'),
                ],
              ),
            ),
            PopupMenuItem<UploadInputType>(
              value: UploadInputType.FILE,
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_rounded),
                  SizedBox(width: 10.0),
                  Text('Arquivo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFormFieldContent() {
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

  Widget _btnSendTextMessageContent() {
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

  Future<void> _onShowDatePicker() async {
    final DatetimePickerService _service = DatetimePickerService();
    final DateTime _dateTime = await _service.onShowDateTimePicker(context);
    if (_dateTime != null) {
      WsMessage _message = WsMessage(
        messageContent: MessageContent(
          messageType: MessageType.TEXT,
          value: DateFormat("dd/MM/yyyy", "pt_BR").format(_dateTime),
        ),
      );
      await widget.connection.onSendMessage(_message);
    }
  }

  Future<void> _onSelectFile(UploadInputType type, WsMessage message) async {
    final FilePickerService _filePickerService = FilePickerService();
    switch (type) {
      case UploadInputType.GALERY:
        final File _image = await _filePickerService.openGalery();
        if (_image == null) break;
        final String _mimeType = lookupMimeType(_image.path);
        final String _base64 = UriData.fromBytes(
          _image.readAsBytesSync(),
          mimeType: _mimeType,
        ).toString();
        WsMessage _message = WsMessage(
          fileContent: FileContent(
            fileType: message.uploadContent.fileType,
            value: _base64,
            name: "nome qualquer",
          ),
        );
        await widget.connection.onSendMessage(_message);
        break;
      case UploadInputType.FILE:
        final File _file = await _filePickerService.openFileStorage();
        if (_file == null) break;
        final String _mimeType = lookupMimeType(_file.path);
        final String _base64 = UriData.fromBytes(
          _file.readAsBytesSync(),
          mimeType: _mimeType,
        ).toString();
        WsMessage _message = WsMessage(
          fileContent: FileContent(
            fileType: message.uploadContent.fileType,
            value: _base64,
            name: "nome qualquer",
          ),
        );
        await widget.connection.onSendMessage(_message);
        break;
      case UploadInputType.CAMERA:
        final File _image = await _filePickerService.openCamera();
        if (_image == null) break;
        final String _mimeType = lookupMimeType(_image.path);
        final String _base64 = UriData.fromBytes(
          _image.readAsBytesSync(),
          mimeType: _mimeType,
        ).toString();
        WsMessage _message = WsMessage(
          fileContent: FileContent(
            fileType: message.uploadContent.fileType,
            value: _base64,
            name: "nome qualquer",
          ),
        );
        await widget.connection.onSendMessage(_message);
        break;
    }
  }

  Future<void> _onSendTextMessage(String message) async {
    if (message.trim().isNotEmpty) {
      WsMessage _message = WsMessage(
        messageContent: MessageContent(
          messageType: MessageType.TEXT,
          value: message.trim(),
        ),
      );
      await widget.connection
          .onSendMessage(_message)
          .whenComplete(() => _messageText.clear());
      _messageFocus.requestFocus();
    }
  }
}
