import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

class ContentErrorWidget extends StatelessWidget {
  final Color background;
  final Color borderColor;
  final double padding;
  final double margin;
  final double radius;
  final double opacity;
  final String messageLabel;
  final String buttonLabel;
  final DioError messageError;
  final Function function;

  const ContentErrorWidget({
    this.background: Colors.transparent,
    this.borderColor: Colors.transparent,
    this.padding: 0.0,
    this.margin: 0.0,
    this.radius: 0.0,
    this.opacity: 0.0,
    this.messageLabel,
    this.buttonLabel: "",
    this.messageError,
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
                          _messageErrorWidget(context),
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

  Widget _messageErrorWidget(BuildContext context) {
    String _message = "Ocorreu um erro inesperado.";
    String _messageErrors = "";
    switch (messageError?.response?.statusCode) {
      case 400:
        if (messageError.response.data["errors"] != null) {
          jsonDecode(jsonEncode(messageError.response.data["errors"]))
              .forEach((key, value) {
            if (value == null) return;
            String _key =
                key.replaceAll(RegExp(r'[^a-zA-Z]'), "").toLowerCase();
            _messageErrors += "* $_key: $value\n";
          });
        }

        _message = "[400] Ocorreram os seguintes errors:\n\n";
        break;
      case 401:
        _message = "[401] Você não tem permissão para acessar este conteúdo.";
        break;
      case 403:
        _message = "[403] Credenciais informadas estão incorretas.";
        break;
      case 404:
        _message = "[404] Nenhum registro encontrado!";
        break;
      case 500:
        _message = "[500] Ocorreu um erro interno no servidor.\n"
            "Tente novamente mais tarde.";
        break;
      case 502:
        _message = "[502] Servidor está temporariamente indisponível.\n"
            "Tente novamente em instantes.";
        break;
      case 503:
        _message = "[503] Servidor está temporariamente indisponível.\n"
            "Tente novamente em instantes.";
        break;
      default:
        break;
    }

    switch (messageError?.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        _message = "[TIMEOUT] Servidor não está respondendo.\nVerifique sua "
            "conexão com a internet ou tente novamente em instantes.";
        break;
      case DioErrorType.SEND_TIMEOUT:
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        break;
      case DioErrorType.RESPONSE:
        break;
      case DioErrorType.CANCEL:
        break;
      case DioErrorType.DEFAULT:
        _message = "[DEFAULT] Servidor não está respondendo.\nVerifique sua "
            "conexão com a internet ou tente novamente em instantes.";
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "$_message",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textColor,
            ),
          ),
          Text(
            "$_messageErrors",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return FlatButton(
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      disabledColor: Theme.of(context).canvasColor,
      color: AppColors.primary,
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      child: Text(buttonLabel),
    );
  }
}
