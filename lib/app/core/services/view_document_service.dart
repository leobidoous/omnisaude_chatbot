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
            return Scaffold(
              body: PDF().cachedFromUrl(
                url,
                placeholder: (double progress) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                            strokeWidth: 1.5,
                          ),
                        ],
                      ),
                    ],
                  );
                },
                errorWidget: (dynamic error) =>
                    Center(child: Text(error.toString())),
              ),
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
