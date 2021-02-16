import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' hide context;
import 'package:rx_notifier/rx_notifier.dart';

import '../../core/enums/enums.dart';
import '../../core/models/file_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/file_picker_service.dart';
import '../../shared/loading/loading_widget.dart';
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
  final UploadContentController _store = new UploadContentController();
  final FilePickerService _service = new FilePickerService();

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (context) {
        if (_store.uploadStatus.value == Status.LOADING) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
              right: 12.5,
              left: 12.5,
            ),
            child: LoadingWidget(opacity: 1.0),
          );
        }
        return IconButton(
          iconSize: 30.0,
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        width: 0.1,
                      ),
                      color: Theme.of(context).backgroundColor,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          onTap: () => _openCamera(context),
                          title: Text(
                            "Câmera",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          leading: Icon(
                            Icons.camera_alt_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          color: Theme.of(context).cardColor,
                        ),
                        ListTile(
                          onTap: () => _openGallery(context),
                          title: Text(
                            "Galeria",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          leading: Icon(
                            Icons.photo_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          color: Theme.of(context).cardColor,
                        ),
                        ListTile(
                          onTap: () => _openFilePicker(context),
                          title: Text(
                            "Documentos",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          leading: Icon(
                            Icons.insert_drive_file_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          color: Theme.of(context).cardColor,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: FlatButton(
                            onPressed: () => Navigator.pop(context),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            textColor: Colors.white,
                            child: Text("Cancelar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
          icon: Icon(Icons.attach_file_rounded),
        );
      },
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    await _service
        .openCamera()
        .then(
          (file) async {
            if (file == null) return;
            _store.uploadStatus.value = Status.LOADING;
            Navigator.pop(context);
            final String _mimeType = lookupMimeType(file.path);
            await _service.onCropImage(file).then(
              (value) async {
                final _filename = basename(file.path);
                final String _base64 = UriData.fromBytes(
                  file.readAsBytesSync(),
                  mimeType: _mimeType,
                ).toString();
                final WsMessage _message = WsMessage(
                  fileContent: FileContent(
                    fileType: widget.message.uploadContent?.fileType,
                    name: _filename,
                    value: _base64,
                  ),
                );
                await widget.onSendMessage(_message);
              },
            );
          },
        )
        .catchError((onError) => _onErrorSendFile())
        .whenComplete(() => _store.uploadStatus.value = Status.SUCCESS);
  }

  Future<void> _openGallery(BuildContext context) async {
    await _service
        .openGallery()
        .then(
          (file) async {
            if (file == null) return;
            _store.uploadStatus.value = Status.LOADING;
            Navigator.pop(context);
            await _service.onCropImage(file).then(
              (value) async {
                final String _mimeType = lookupMimeType(file.path);
                final _filename = basename(file.path);
                final String _base64 = UriData.fromBytes(
                  file.readAsBytesSync(),
                  mimeType: _mimeType,
                ).toString();
                final WsMessage _message = WsMessage(
                  fileContent: FileContent(
                    fileType: widget.message.uploadContent?.fileType,
                    name: _filename,
                    value: _base64,
                  ),
                );
                await widget.onSendMessage(_message);
              },
            );
          },
        )
        .catchError((onError) => _onErrorSendFile())
        .whenComplete(() => _store.uploadStatus.value = Status.SUCCESS);
  }

  Future<void> _openFilePicker(BuildContext context) async {
    await _service
        .openFileStorage()
        .then(
          (file) async {
            if (file == null) return;
            _store.uploadStatus.value = Status.LOADING;
            Navigator.pop(context);
            file.forEach(
              (element) async {
                final String _mimeType = lookupMimeType(element.path);
                final _filename = basename(element.path);
                final String _base64 = UriData.fromBytes(
                  element.readAsBytesSync(),
                  mimeType: _mimeType,
                ).toString();
                final WsMessage _message = WsMessage(
                  fileContent: FileContent(
                    fileType: widget.message.uploadContent?.fileType,
                    name: _filename,
                    value: _base64,
                  ),
                );
                await widget.onSendMessage(_message);
              },
            );
          },
        )
        .catchError((onError) => _onErrorSendFile())
        .whenComplete(() => _store.uploadStatus.value = Status.SUCCESS);
  }

  void _onErrorSendFile() {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2500),
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.95),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: Text(
          "Ocorreu um erro ao enviar o arquivo.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
      ),
    );
  }
}
