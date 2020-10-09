import 'dart:async';
import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/core/models/ws_message_model.dart';
import 'package:universal_html/html.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebConnection extends Disposable {
  final String _url;
  final String _username;
  final String _avatarUrl;
  String _peer;

  WebConnection(this._url, this._username, this._avatarUrl);

  HtmlWebSocketChannel _channel;
  WebSocket _webSocket;

  // ignore: missing_return
  Future<Stream> onInitSession() async {
    try {
      _webSocket = WebSocket(_url);
      _channel = HtmlWebSocketChannel(_webSocket);

      return _channel.stream;
    } catch (e) {
      print("Erro ao iniciar a conexão: $e");
    }
  }

  Future<void> onSendMessage(WsMessage message) async {
    try {
      message.username = _username;
      message.avatarUrl = _avatarUrl;

      _channel.sink.add(jsonEncode(message));
      print("-----> *** MENSAGEM ENVIADA: ${message.toJson()}\n");
    } catch (e) {
      print(e);
    }
  }

  Future<void> onCloseSession() async {
    try {
      await _channel.sink.close(status.normalClosure, "Conexão encerrada");
      _webSocket.close();
      print("\t--: CONEXÃO ENCERRADA");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    onCloseSession();
  }
}
