import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

class EmptyWidget extends StatelessWidget {
  final double padding;
  final double margin;
  final double radius;
  final String message;
  final Function function;
  final String buttonLabel;

  const EmptyWidget({
    this.padding: 0.0,
    this.margin: 0.0,
    this.radius: 0.0,
    this.message,
    this.function,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(margin),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(radius),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: "Comfortaa",
                        ),
                      ),
                      _buttonWidget(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonWidget(BuildContext context) {
    if (function == null || buttonLabel == null) return Column();
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
