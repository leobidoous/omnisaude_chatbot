import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:mime/mime.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/view_document_service.dart';
import 'package:omnisaude_chatbot/app/core/services/view_photo_service.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/datetime_on_message/datetime_on_message_widget.dart';

class FileContentWidget extends StatefulWidget {
  final WsMessage message;
  final String userPeer;

  const FileContentWidget(
      {Key key, @required this.message, @required this.userPeer})
      : super(key: key);

  @override
  _FileContentWidgetState createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget> {
  @override
  Widget build(BuildContext context) {
    final WsMessage _message = widget.message;
    final String _userPeer = widget.userPeer;
    final String _mimeType = lookupMimeType(_message.fileContent.value);
    if (lookupMimeType(_message.fileContent.value).contains("image")) {
      if (_message.peer == _userPeer) {
        return _userContent(_message.fileContent, _imageContent);
      } else {
        return _botContent(_message.fileContent, _imageContent);
      }
    } else if (_mimeType == "application/pdf") {
      if (_message.peer == _userPeer) {
        return _userContent(_message.fileContent, _pdfContent);
      } else {
        return _botContent(_message.fileContent, _pdfContent);
      }
    }
    return Container(
      height: 100.0,
      color: Colors.grey,
    );
  }

  Widget _userContent(
      FileContent message, Function(String, String, String, Color) child) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.2,
        bottom: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                    child: child(
                      message.value,
                      message.name,
                      message.comment,
                      Theme.of(context).cardColor,
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                DatetimeOnMessageWidget(
                  dateTime: DateTime.parse(widget.message.datetime),
                  message: widget.message,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          AvatarWidget(
            url: widget.message.avatarUrl,
            width: 30.0,
            height: 30.0,
            radius: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _botContent(
      FileContent message, Function(String, String, String, Color) child) {
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
          const AvatarWidget(
            width: 30.0,
            height: 30.0,
            radius: 10.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    child: child(
                      message.value,
                      message.name,
                      message.comment,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
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

  Widget _imageContent(String url, String filename, String comment, Color color) {
    return Container(
      color: color,
      height: 200.0,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final ViewPhotoService _viewPhotoService = ViewPhotoService();
                _viewPhotoService.onViewSinglePhoto(context, url);
                _viewPhotoService.dispose();
              },
              child: AvatarWidget(
                url: url,
                boxFit: BoxFit.cover,
                radius: 10.0,
              ),
            ),
          ),
          _commentContent(comment),
        ],
      ),
    );
  }

  Widget _pdfContent(String url, String filename, String comment, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
            height: 200.0,
            child: GestureDetector(
              onTap: () {
                final ViewDocumentService _service = ViewDocumentService();
                _service.onViewSingleDocument(context, url);
                _service.dispose();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        PDF().fromUrl(url),
                        Container(color: Colors.transparent),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    color: Theme.of(context).cardColor,
                    child: Row(
                      children: [
                        Icon(Icons.insert_drive_file_rounded),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            "$filename",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(Icons.download_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _commentContent(comment),
        ],
      ),
    );
  }

  Widget _commentContent(String comment) {
    if (comment == null) return Container();
    else if (comment.trim().isEmpty) return Container();
    return SelectableText(comment);
  }
}
