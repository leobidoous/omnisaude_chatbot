import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoService extends Disposable {
  Future<void> onViewSinglePhoto(BuildContext context, String url) async {
    try {
      await showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black87,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.black87),
                    imageProvider: CachedNetworkImageProvider(url),
                    loadingBuilder: (context, image) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: AppColors.primary,
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
