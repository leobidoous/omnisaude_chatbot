import 'dart:async';
import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection extends Disposable {
  final String _url;
  final String _username;
  final String _avatarUrl;
  String _userPeer;

  Connection(this._url, this._username, this._avatarUrl);

  final StreamController _controller = StreamController<WsMessage>();
  WebSocketChannel _channel;

  Future<StreamController> onInitSession() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));

      _channel.stream.listen((event) {
        final WsMessage _message = WsMessage.fromJson(jsonDecode(event));
        if (_message.eventContent?.eventType == EventType.CONNECTED) {
          _userPeer = _message.eventContent.message;
        }
        _controller.sink.add(_message);
        onMessageReceived(_message);
      }, onError: (onError) {
        print("Erro de conexão: $onError");
      }, onDone: () {
        print("Conexão encerrada!");
      });
      return _controller;
    } catch (e) {
      print("Erro ao iniciar a conexão: $e");
      throw e;
    }
  }

  Future<void> onMessageReceived(WsMessage message) async {
    try {
      print("-----> ### MENSAGEM RECEBIDA: ${message.toJson()}\n");
    } catch (e) {
      print(e);
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

  String getUserPeer() => _userPeer;

  Future<void> onCloseSession() async {
    try {
      await _channel.sink.close(status.normalClosure, "Conexão encerrada");
      _channel.sink.close();
      _controller.close();
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
