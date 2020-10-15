import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class MobileConnection extends Disposable {
  final String _url;
  final String _username;
  final String _avatarUrl;
  String _userPeer;

  MobileConnection(this._url, this._username, this._avatarUrl);

  final StreamController _controller = StreamController<WsMessage>();
  IOWebSocketChannel _channel;
  WebSocket _webSocket;

  Future<StreamController> onInitSession() async {
    try {
      _webSocket = await WebSocket.connect(_url);
      _channel = IOWebSocketChannel(_webSocket);

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
      print("Erro ao iniciar a conexão no package: $e");
      throw e;
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

  Future<void> onMessageReceived(WsMessage message) async {
    try {
      print("-----> ### MENSAGEM RECEBIDA: ${message.toJson()}\n");
    } catch (e) {
      print(e);
    }
  }

  String getUserPeer() => _userPeer;

  WebSocketSink getStreamChannel() => _channel?.sink;

  Future<void> onCloseSession() async {
    try {
      await _channel.sink.close(status.normalClosure, "Conexão encerrada");
      _webSocket.close();
      _controller.close();
      print("--: CONEXÃO ENCERRADA");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    onCloseSession();
  }
}
