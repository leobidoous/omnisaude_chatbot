import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/file_content_model.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/core/services/view_pdf_service.dart';
import 'package:omnisaude_chatbot/app/core/services/view_photo_service.dart';
import 'package:omnisaude_chatbot/app/shared/image/image_widget.dart';
import 'package:omnisaude_chatbot/app/shared/loading/loading_widget.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class FileContentWidget extends StatefulWidget {
  final WsMessage message;

  const FileContentWidget({Key key, @required this.message}) : super(key: key);

  @override
  _FileContentWidgetState createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget>
    with AutomaticKeepAliveClientMixin {
  final RxNotifier<Status> _status = new RxNotifier(Status.NONE);

  @override
  dispose() {
    _status.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final FileContent _message = widget.message.fileContent;

    switch (_message.fileType) {
      case ContentFileType.IMAGE:
        return _imageContent(_message.value, _message.name, _message.comment);
      case ContentFileType.PDF:
        return _pdfContent(_message.value, _message.name, _message.comment);
      default:
        return _anyContent(_message.value, _message.name, _message.comment);
    }
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
                final ViewPDFService _service = new ViewPDFService();
                _service.showPDFViwer(
                  context,
                  fromPDFType: FromPDFType.URL,
                  title: filename,
                  url: url,
                  changeStatus: ([Status status]) {
                    if (status == null) return _status.value;
                    return _status.value = status;
                  },
                );
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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        comment,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
