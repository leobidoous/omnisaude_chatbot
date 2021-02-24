import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/file_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/view_document_service.dart';
import '../../core/services/view_photo_service.dart';
import '../../shared/image/image_widget.dart';
import '../../shared/loading/loading_widget.dart';

class FileContentWidget extends StatefulWidget {
  final WsMessage message;

  const FileContentWidget({Key key, @required this.message}) : super(key: key);

  @override
  _FileContentWidgetState createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final FileContent _message = widget.message.fileContent;
    final String _mimeType = lookupMimeType(_message.value);

    if (lookupMimeType(_message.value).contains("image")) {
      return _imageContent(_message.value, _message.name, _message.comment);
    } else if (_mimeType == "application/pdf") {
      return _pdfContent(_message.value, _message.name, _message.comment);
    }
    return _anyContent(_message.value, _message.name, _message.comment);
  }

  Widget _imageContent(String url, String filename, String comment) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      padding: const EdgeInsets.all(2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final ViewPhotoService _viewPhotoService = ViewPhotoService();
                await _viewPhotoService.onViewSinglePhoto(context, url);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ImageWidget(url: url, fit: BoxFit.cover, radius: 20.0),
              ),
            ),
          ),
          _commentContent(comment),
        ],
      ),
    );
  }

  Widget _pdfContent(String url, String filename, String comment) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final ViewDocumentService _service = new ViewDocumentService();
                await _service.onViewSingleDocument(context, url);
                _service.dispose();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(2.5),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            child: PDF(
                              fitEachPage: true,
                              autoSpacing: false,
                              fitPolicy: FitPolicy.WIDTH,
                              swipeHorizontal: true,
                              pageSnap: false,
                            ).cachedFromUrl(
                              url,
                              placeholder: (double progress) {
                                return new LoadingWidget(opacity: 0.25);
                              },
                            ),
                          ),
                          Container(color: Colors.transparent),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            "$filename",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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

  Widget _anyContent(String url, String filename, String comment) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              await launch(url, forceWebView: true, enableJavaScript: true)
                  .catchError((onError) => null);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file_rounded,
                      color: Colors.white),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      "$filename",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Icon(Icons.download_rounded, color: Colors.white),
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
    return Text(
      comment,
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }
}
