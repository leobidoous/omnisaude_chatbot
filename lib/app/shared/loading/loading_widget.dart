import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color background;
  final Color borderColor;
  final double padding;
  final double margin;
  final double radius;
  final double opacity;
  final String message;

  const LoadingWidget({
    this.background: Colors.transparent,
    this.borderColor: Colors.transparent,
    this.padding: 0.0,
    this.margin: 0.0,
    this.radius: 0.0,
    this.opacity: 0.0,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: opacity != 1.0 ? StackFit.expand : StackFit.passthrough,
      children: [
        Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(margin),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).canvasColor.withOpacity(0.5),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                  color: background,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(width: 0.5, color: borderColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Card(
                    elevation: 0.0,
                    margin: EdgeInsets.zero,
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoActivityIndicator(),
                          _buildMessageWidget(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageWidget(BuildContext context) {
    if (message == null) return Column();
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontFamily: "Comfortaa",
        ),
      ),
    );
  }
}
