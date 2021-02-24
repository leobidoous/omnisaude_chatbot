import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

class ContentErrorWidget extends StatelessWidget {
  final Color background;
  final double padding;
  final double margin;
  final double radius;
  final double opacity;
  final String messageLabel;
  final String buttonLabel;
  final Function function;

  const ContentErrorWidget({
    this.background: Colors.transparent,
    this.padding: 0.0,
    this.margin: 0.0,
    this.radius: 0.0,
    this.opacity: 0.0,
    this.messageLabel,
    this.buttonLabel: "",
    this.function,
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
              borderRadius: BorderRadius.circular(radius),
              color: AppColors.background,
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
                ),
                margin: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Card(
                    elevation: 0.0,
                    color: Colors.transparent,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.error_rounded,
                            size: 50.0,
                            color: Colors.red,
                          ),
                          _messageLabelWidget(context),
                          _buttonWidget(context),
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

  Widget _messageLabelWidget(BuildContext context) {
    if (messageLabel == null) return Column();
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(
        messageLabel,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textColor,
          fontFamily: "Comfortaa",
        ),
      ),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: FlatButton(
        onPressed: function,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        disabledColor: Theme.of(context).canvasColor,
        color: AppColors.primary,
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        child: Text(buttonLabel),
      ),
    );
  }
}
