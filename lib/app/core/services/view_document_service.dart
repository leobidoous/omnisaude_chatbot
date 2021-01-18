import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/shared/loading/loading_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:share/share.dart';

class ViewDocumentService extends Disposable {
  final RxNotifier<Status> _downloadStatus = new RxNotifier(Status.NONE);

  Future<void> onViewSingleDocument(BuildContext context, String url) async {
    try {
      await showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).primaryColor,
              automaticallyImplyLeading: false,
              actions: [
                RxBuilder(builder: (_) {
                  if (_downloadStatus.value == Status.LOADING) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: LoadingWidget(
                        opacity: 1.0,
                        background: Theme.of(context).primaryColor,
                        showShadow: false,
                      ),
                    );
                  }
                  return FlatButton(
                    onPressed: () async => _onSharedPDF(context, url),
                    color: Theme.of(context).primaryColor,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Icon(Icons.share_rounded, color: Colors.white),
                  );
                }),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  color: Theme.of(context).primaryColor,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Icon(Icons.close_rounded, color: Colors.white),
                )
              ],
            ),
            body: PDF().cachedFromUrl(
              url,
              placeholder: (double progress) {
                return LoadingWidget(
                  message: "Carregando documento",
                  margin: 20.0,
                  padding: 20.0,
                  radius: 20.0,
                );
              },
              errorWidget: (dynamic error) {
                return Center(child: Text(error.toString()));
              },
            ),
          );
        },
      );
    } catch (e) {
      print("impossível visualizar a foto unica: $e");
    }
  }

  void _onSharedPDF(BuildContext context, String url) async {
    final RenderBox box = context.findRenderObject();
    final File _file = await _createFileOfPdfUrl(url);
    await Share.shareFiles(
      [_file.path],
      text: "Compartilhar documento",
      mimeTypes: ["applications/pdf"],
      subject: basename(_file.path),
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<File> _createFileOfPdfUrl(String url) async {
    _downloadStatus.value = Status.LOADING;
    final Completer<File> completer = Completer();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      final File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      _downloadStatus.value = Status.ERROR;
      throw Exception('Error parsing asset file!');
    }

    _downloadStatus.value = Status.SUCCESS;
    return completer.future;
  }

  //dispose will be called automatically
  @override
  void dispose() {
    _downloadStatus.dispose();
  }
}
