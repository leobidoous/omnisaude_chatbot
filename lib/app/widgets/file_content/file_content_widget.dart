import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:mime/mime.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/view_document_service.dart';
import 'package:omnisaude_chatbot/app/core/services/view_photo_service.dart';
import 'package:omnisaude_chatbot/app/widgets/avatar/avatar_widget.dart';

class FileContentWidget extends StatefulWidget {
  final WsMessage message;
  final Color color;

  const FileContentWidget(
      {Key key, @required this.message, @required this.color})
      : super(key: key);

  @override
  _FileContentWidgetState createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget> {
  @override
  Widget build(BuildContext context) {
    final FileContent _message = widget.message.fileContent;
    final String _mimeType = lookupMimeType(_message.value);
    final Color _color = widget.color;

    if (lookupMimeType(_message.value).contains("image")) {
      return _imageContent(
        _message.value,
        _message.name,
        _message.comment,
        _color,
      );
    } else if (_mimeType == "application/pdf") {
      return _pdfContent(
        _message.value,
        _message.name,
        _message.comment,
        _color,
      );
    }
    return Container();
  }

  Widget _imageContent(
      String url, String filename, String comment, Color color) {
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
    if (comment == null)
      return Container();
    else if (comment.trim().isEmpty) return Container();
    return SelectableText(comment);
  }
}
