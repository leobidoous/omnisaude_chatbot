import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/shared/loading/loading_widget.dart';

class ImageWidget extends StatefulWidget {
  final String url;
  final String asset;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;
  final Alignment alignment;

  const ImageWidget({
    Key key,
    this.url,
    this.asset: "assets/avatar/bot.png",
    this.width,
    this.height,
    this.fit,
    this.radius: 0.0,
    this.alignment: Alignment.center,
  }) : super(key: key);

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.url == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: Image.asset(
          widget.asset,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          package: "omnisaude_chatbot",
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: CachedNetworkImage(
        width: widget.width,
        height: widget.height,
        placeholder: (BuildContext context, String url) {
          return LoadingWidget(opacity: 0.85, background: Colors.transparent);
        },
        errorWidget: (BuildContext context, String url, dynamic error) {
          return Image.asset(
            widget.asset,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
            alignment: widget.alignment,
            package: "omnisaude_chatbot",
          );
        },
        imageBuilder: (BuildContext context, ImageProvider image) {
          return GestureDetector(
            onTap: () async {},
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: widget.alignment,
                  image: image,
                  fit: widget.fit,
                ),
              ),
            ),
          );
        },
        imageUrl: widget.url,
      ),
    );
  }
}
