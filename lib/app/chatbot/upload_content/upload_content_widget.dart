import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../core/enums/enums.dart';
import '../../core/models/file_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/file_picker_service.dart';

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
  final FilePickerService _service = new FilePickerService();

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await _service.openFileStorage().then(
              (files) async {
            if (files == null) return;
            files.forEach(
                  (file) {
                WsMessage _message = WsMessage(
                  fileContent: FileContent(
                    fileType: ContentFileType.ANY,
                    name: basename(file),
                    value: file,
                  ),
                );
                widget.onSendMessage(_message);
              },
            );
          },
        );
      },
      iconSize: 30.0,
      tooltip: "Escolher mídia",
      icon: Icon(Icons.attach_file_rounded),
    );
  }
}
