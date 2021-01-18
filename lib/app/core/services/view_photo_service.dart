import 'package:cached_network_image/cached_network_image.dart';
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
              body: Stack(
                fit: StackFit.expand,
                children: [
                  PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Theme.of(context).canvasColor.withOpacity(0.25),
                    ),
                    imageProvider: CachedNetworkImageProvider(url),
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
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("impossível visualizar a foto unica: $e");
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
