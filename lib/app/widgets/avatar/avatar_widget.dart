import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AvatarWidget extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final String imagePath;
  final String url;
  final BoxFit boxFit;

  const AvatarWidget(
      {Key key,
      this.height,
      this.width,
      this.imagePath: "assets/avatar/bot.png",
      this.url,
      this.radius: 0.0,
      this.boxFit: BoxFit.fill})
      : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: CachedNetworkImage(
        width: widget.width,
        height: widget.height,
        placeholder: (BuildContext context, String url) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).backgroundColor,
                ),
                padding: EdgeInsets.all(5.0),
                constraints: BoxConstraints(maxHeight: 30.0, maxWidth: 30.0),
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  strokeWidth: 1.5,
                ),
              ),
            ],
          );
        },
        errorWidget: (BuildContext context, String url, dynamic error) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: Image.asset(widget.imagePath, package: "omnisaude_chatbot"),
          );
        },
        imageBuilder: (BuildContext context, ImageProvider image) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              image: DecorationImage(image: image, fit: widget.boxFit),
            ),
          );
        },
        imageUrl: widget.url ?? "",
      ),
    );
  }
}
