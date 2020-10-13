import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/file_picker_service.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/datetime_on_message/datetime_on_message_widget.dart';

class UploadContentWidget extends StatefulWidget {
  final Future<void> Function(WsMessage) onSendMessage;
  final WsMessage message;
  final String peer;
  final bool enabled;

  const UploadContentWidget(
      {Key key,
      @required this.onSendMessage,
      @required this.message,
      @required this.peer,
      @required this.enabled})
      : super(key: key);

  @override
  _UploadContentWidgetState createState() => _UploadContentWidgetState();
}

class _UploadContentWidgetState extends State<UploadContentWidget> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: _buildUploadContent(),
    );
  }

  Widget _buildUploadContent() {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.2,
        bottom: 5.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const AvatarWidget(width: 30.0, height: 30.0, radius: 10.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: _btnUploadFileContent()),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(
                  dateTime: DateTime.parse(widget.message.datetime),
                  message: widget.message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnUploadFileContent() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          ),
          child: GestureDetector(
            onTap: _onChooseFiles,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              child: Row(
                children: [
                  Icon(Icons.upload_rounded),
                  Text("Escolher arquivo"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onChooseFiles() async {
    try {
      final FilePickerService _service = FilePickerService();
      await _service.getFile();
      _onSendMessage();
      _service.dispose();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onSendMessage() async {
    try {
      final WsMessage _message = WsMessage(
        fileContent: FileContent(
          comment: "",
          value: "",
          fileType: ContentFileType.ANY,
        ),
      );
      widget.onSendMessage(_message);
    } catch (e) {
      print(e);
    }
  }

}
