import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:universal_html/html.dart';

import '../../core/enums/enums.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/file_picker_service.dart';
import 'upload_content_controller.dart';

class UploadContentWidget extends StatefulWidget {
  final Future<void> Function(WsMessage) onSendMessage;
  final WsMessage message;

  const UploadContentWidget({
    Key key,
    @required this.onSendMessage,
    @required this.message,
  }) : super(key: key);

  @override
  _UploadContentWidgetState createState() => _UploadContentWidgetState();
}

class _UploadContentWidgetState extends State<UploadContentWidget> {
  final UploadContentController _controller = new UploadContentController();
  final FilePickerService _service = new FilePickerService();

  Widget _webcamWidget = HtmlElementView(key: UniqueKey(), viewType: 'webcam');
  final VideoElement _webcamVideoElement = new VideoElement();

  @override
  void initState() {
    ui.platformViewRegistry.registerViewFactory(
      'webcam',
      (int viewId) => _webcamVideoElement,
    );
    super.initState();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.attach_file_rounded, size: 25.0),
      tooltip: "Escolher mídia",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      padding: const EdgeInsets.only(bottom: 5.0),
      itemBuilder: (BuildContext context) => _platformRenderWidget(),
    );
  }

  List<PopupMenuEntry<dynamic>> _platformRenderWidget() {
    Function _camera = () async {
      await _service.openCamera().then(
        (value) async {
          if (value == null) return;
          final String _mimeType = lookupMimeType(value.path);
          final String _base64 = UriData.fromBytes(
            value.readAsBytesSync(),
            mimeType: _mimeType,
          ).toString();
          WsMessage _message = WsMessage(
            fileContent: FileContent(
              fileType: widget.message.uploadContent.fileType,
              value: _base64,
            ),
          );
          await widget.onSendMessage(_message);
        },
      );
    };
    Function _gallery = () async {
      await _service.openGallery().then(
        (value) async {
          if (value == null) return;
          final String _mimeType = lookupMimeType(value.path);
          final String _base64 = UriData.fromBytes(
            value.readAsBytesSync(),
            mimeType: _mimeType,
          ).toString();
          WsMessage _message = WsMessage(
            fileContent: FileContent(
              fileType: widget.message.uploadContent.fileType,
              value: _base64,
            ),
          );
          await widget.onSendMessage(_message);
        },
      );
    };
    Function _file = () async {
      await _service.openFileStorage().then(
        (value) async {
          if (value == null) return;
          value.forEach((element) async {
            final String _mimeType = lookupMimeType(element.path);
            final String _base64 = UriData.fromBytes(
              element.readAsBytesSync(),
              mimeType: _mimeType,
            ).toString();
            WsMessage _message = WsMessage(
              fileContent: FileContent(
                fileType: widget.message.uploadContent.fileType,
                value: _base64,
              ),
            );
            await widget.onSendMessage(_message);
          });
        },
      );
    };
    if (kIsWeb) {
      _camera = null;
      _gallery = () async {
        Navigator.pop(context);
        await _service.openWebFileStorage(type: "image").then(
          (files) async {
            if (files == null) return;
            files.forEach(
              (file) {
                WsMessage _message = WsMessage(
                  fileContent: FileContent(
                    fileType: ContentFileType.IMAGE,
                    value: file,
                  ),
                );
                widget.onSendMessage(_message);
              },
            );
          },
        );
      };
      _file = () async {
        Navigator.pop(context);
        await _service.openWebFileStorage().then(
          (files) async {
            if (files == null) return;
            files.forEach(
              (file) {
                WsMessage _message = WsMessage(
                  fileContent: FileContent(
                    fileType: ContentFileType.CUSTOM,
                    value: file,
                  ),
                );
                widget.onSendMessage(_message);
              },
            );
          },
        );
      };
    }
    return <PopupMenuEntry>[
      _uploadItemWidget(Icons.camera_alt_rounded, _camera, "Câmera"),
      _uploadItemWidget(Icons.photo_rounded, _gallery, "Galeria"),
      _uploadItemWidget(Icons.insert_drive_file, _file, "Documento"),
    ];
  }

  Widget _uploadItemWidget(IconData iconData, Function func, String label) {
    return PopupMenuItem(
      child: ListTile(
        enabled: func != null,
        onTap: func,
        title: Text(label),
        leading: Icon(iconData),
      ),
    );
  }
}
