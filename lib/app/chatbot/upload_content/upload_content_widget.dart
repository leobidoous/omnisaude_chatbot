import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' hide context;
import 'package:rx_notifier/rx_notifier.dart';

import '../../core/enums/enums.dart';
import '../../core/models/file_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/file_picker_service.dart';
import '../../shared/loading/loading_widget.dart';
import '../../shared/stylesheet/app_colors.dart';
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
          return IconButton(
            onPressed: null,
            iconSize: 30.0,
            icon: Column(
              children: [
                Tooltip(
                  message: 'Enviando arquivo',
                  child: LoadingWidget(opacity: 1.0, height: 30.0, width: 30.0),
                ),
              ],
            ),
          );
        }
        return IconButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _chooseUploadTypeSheet(),
            );
          },
          color: AppColors.textColor.withOpacity(0.5),
          icon: Icon(Icons.attach_file_rounded),
          iconSize: 30.0,
        );
      },
    );
  }

  Widget _chooseUploadTypeSheet() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: AppColors.textColor, width: 0.1),
          color: AppColors.background,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              onTap: () => _openCamera(context),
              title: Text(
                "Câmera",
                style: TextStyle(color: AppColors.textColor),
              ),
              leading: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
            ),
            Divider(height: 0.0, color: Theme.of(context).cardColor),
            ListTile(
              onTap: () => _openGallery(context),
              title: Text(
                "Galeria",
                style: TextStyle(color: AppColors.textColor),
              ),
              leading: Icon(Icons.photo_rounded, color: AppColors.primary),
            ),
            Divider(height: 0.0, color: Theme.of(context).cardColor),
            ListTile(
              onTap: () => _openFilePicker(context),
              title: Text(
                "Documentos",
                style: TextStyle(color: AppColors.textColor),
              ),
              leading: Icon(
                Icons.insert_drive_file_rounded,
                color: AppColors.primary,
              ),
            ),
            Divider(height: 0.0, color: Theme.of(context).cardColor),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
  }

  Future<void> _openCamera(BuildContext context) async {
    await _service.openCamera().then(
      (file) async {
        if (file == null) return;
        _store.uploadStatus.value = Status.LOADING;
        final String _mimeType = lookupMimeType(file.path);
        await _service.onCropImage(file).then(
          (value) async {
            Navigator.pop(context);
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
    ).catchError((onError) => _errorSendFile());
  }

  Future<void> _openGallery(BuildContext context) async {
    await _service.openGallery().then(
      (file) async {
        if (file == null) return;
        _store.uploadStatus.value = Status.LOADING;
        await _service.onCropImage(file).then(
          (value) async {
            Navigator.pop(context);
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
    ).catchError((onError) => _errorSendFile());
  }

  Future<void> _openFilePicker(BuildContext context) async {
    await _service.openFileStorage().then(
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
    ).catchError((onError) => _errorSendFile());
  }

  void _addCommentOnFile() async {
    //TODO: criar tela para visualizar a imagem cortada e disponibilizar um compo para adicionar um comentario.
  }

  void _errorSendFile() {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2500),
        backgroundColor: AppColors.background.withOpacity(0.95),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: Text(
          "Ocorreu um erro ao enviar o arquivo.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }
}
