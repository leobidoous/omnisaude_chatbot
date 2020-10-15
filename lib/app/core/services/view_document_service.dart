import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ViewDocumentService extends Disposable {
  Future<void> onViewSingleDocument(BuildContext context, String url) async {
    try {
      await showDialog(
          context: context,
          builder: (context) {
            return PDF().cachedFromUrl(
              url,
              placeholder: (double progress) => Center(child: Text('$progress %')),
              errorWidget: (dynamic error) => Center(child: Text(error.toString())),
            );
          });
    } catch (e) {
      print("impossível visualizar a foto unica: $e");
    }
  }
//dispose will be called automatically
  @override
  void dispose() {}
}
