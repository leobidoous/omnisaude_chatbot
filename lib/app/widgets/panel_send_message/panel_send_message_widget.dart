import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:omnisaude_chatbot/app/components/components.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/datetime_picker_service.dart';
import 'package:omnisaude_chatbot/app/core/services/file_picker_service.dart';
import 'package:omnisaude_chatbot/app/widgets/panel_send_message/panel_send_message_controller.dart';

class PanelSendMessageWidget extends StatefulWidget {
  final WsMessage message;
  final Future<void> Function() onScrollListToBottom;
  final Future<void> Function(WsMessage) onSendMessage;

  const PanelSendMessageWidget(
      {Key key, @required this.message, @required this.onScrollListToBottom, @required this.onSendMessage})
      : super(key: key);

  @override
  _PanelSendMessageWidgetState createState() => _PanelSendMessageWidgetState();
}

class _PanelSendMessageWidgetState extends State<PanelSendMessageWidget> {
  final PanelSendMessageController _controller = PanelSendMessageController();
  final TextEditingController _messageText = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  @override
  void initState() {
    _messageFocus.addListener(() {
      if (_messageFocus.hasFocus) {
        widget.onScrollListToBottom();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageFocus.dispose();
    _messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.message;
    _controller.dateEnabled = false;
    _controller.textEnabled = false;
    _controller.attachEnabled = false;

    if (_message.inputContent != null) {
      if (_message.inputContent.inputType == InputType.DATE) {
        _controller.dateEnabled = true;
      } else if (_message.inputContent.inputType == InputType.TEXT) {
        _controller.textEnabled = true;
      }
    } else if (_message.uploadContent != null) {
      _controller.attachEnabled = true;
    } else if (_message.switchContent != null) {
      return Container();
    }
    return _panelSendMessage(_message);
  }

  Widget _panelSendMessage(WsMessage message) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Observer(
        builder: (context) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IgnorePointer(
                ignoring: !_controller.dateEnabled,
                child: Opacity(
                  opacity: _controller.dateEnabled ? 1.0 : 0.3,
                  child: IconButton(
                    iconSize: 30.0,
                    onPressed: _onShowDatePicker,
                    padding: EdgeInsets.zero,
                    color: Theme.of(context).textTheme.headline1.color,
                    icon: Icon(Icons.date_range_rounded),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: !_controller.attachEnabled,
                child: Opacity(
                  opacity: _controller.attachEnabled ? 1.0 : 0.3,
                  child: PopupMenuButton<UploadInputType>(
                    onSelected: (UploadInputType type) async {
                      await _onSelectFile(type, message);
                    },
                    elevation: 0.0,
                    offset: Offset(0.0, -175.0),
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: Theme.of(context).textTheme.headline1.color,
                      size: 30.0,
                    ),
                    padding: EdgeInsets.zero,
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
              ),
              Expanded(
                child: IgnorePointer(
                  ignoring: !_controller.textEnabled,
                  child: Opacity(
                    opacity: _controller.textEnabled ? 1.0 : 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        autofocus: true,
                        focusNode: _messageFocus,
                        controller: _messageText,
                        enabled: _controller.textEnabled,
                        scrollPhysics: BouncingScrollPhysics(),
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          hintText: "Escreva uma mensagem",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
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
                ),
              ),
              IgnorePointer(
                ignoring: !_controller.textEnabled,
                child: Opacity(
                  opacity: _controller.textEnabled ? 1.0 : 0.3,
                  child: IconButton(
                    iconSize: 30.0,
                    onPressed: () => _onSendTextMessage(_messageText.text),
                    padding: EdgeInsets.zero,
                    color: Theme.of(context).textTheme.headline1.color,
                    icon: Icon(Icons.send_rounded),
                  ),
                ),
              ),
            ],
          );
        },
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
      await widget
          .onSendMessage(_message)
          .whenComplete(() => _messageText.clear());
    }
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
      await widget.onSendMessage(_message);
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
        await widget.onSendMessage(_message);
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
        await widget.onSendMessage(_message);
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
        await widget.onSendMessage(_message);
        break;
    }
  }
}
