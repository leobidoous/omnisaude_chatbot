import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoService extends Disposable {
  Future<void> onViewSinglePhoto(BuildContext context, String url) async {
    try {
      await showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black87,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PhotoView(
                        imageProvider: NetworkImage(url),
                        loadingBuilder: (context, image) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                                strokeWidth: 1.5,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
