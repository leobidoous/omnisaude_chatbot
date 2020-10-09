import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/core/models/ws_message_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class MobileConnection extends Disposable {
  final String _url;
  final String _username;
  final String _avatarUrl;
  String _peer;

  MobileConnection(this._url, this._username, this._avatarUrl);

  IOWebSocketChannel _channel;
  WebSocket _webSocket;

  // ignore: missing_return
  Future<Stream> onInitSession() async {
    try {
      _webSocket = await WebSocket.connect(_url);
      _channel = IOWebSocketChannel(_webSocket);

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
