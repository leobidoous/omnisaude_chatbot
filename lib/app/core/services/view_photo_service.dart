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
            return PhotoView(
              imageProvider: NetworkImage(url),
              loadingBuilder: (context, image) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).cardColor,
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                        strokeWidth: 1.5,
                      ),
                    ],
                  ),
                );
              },
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
