import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection extends Disposable {
  final String _url;
  final String _username;
  final String _avatarUrl;
  String _myPeer;

  Connection(this._url, this._username, this._avatarUrl);

  final StreamController<WsMessage> _streamController = StreamController();
  ConnectionStatus connectionStatus = ConnectionStatus.NONE;
  WebSocketChannel _channel;

  Future<StreamController> onInitSession() async {
    _channel = WebSocketChannel.connect(Uri.parse(_url));

    connectionStatus = ConnectionStatus.WAITING;
    _channel.stream.listen(
      (event) async {
        connectionStatus = ConnectionStatus.ACTIVE;
        final WsMessage _message = WsMessage.fromJson(jsonDecode(event));
        if (_message.eventContent?.eventType == EventType.CONNECTED) {
          setUserPeer(_message.eventContent.message);
        }
        _onMessageReceived(_message);
        _streamController.add(_message);
      },
      onError: (onError) async {
        log("Erro de conexão: $onError");
        connectionStatus = ConnectionStatus.ERROR;
        _streamController.addError(onError);
        dispose();
      },
      onDone: () async {
        log("Conexão encerrada!");
        connectionStatus = ConnectionStatus.DONE;
        dispose();
      },
    );
    return _streamController;
  }

  Future<void> _onMessageReceived(WsMessage message) async {
    try {
      log("-----> ### MENSAGEM RECEBIDA: ${message.toJson()}\n");
    } catch (e) {
      log("Erro ao receber mensagem: $e");
    }
  }

  Future<void> onSendMessage(WsMessage message) async {
    try {
      message.username = _username;
      message.avatarUrl = _avatarUrl;

      if (connectionStatus == ConnectionStatus.ACTIVE) {
        _channel.sink.add(jsonEncode(message));
        log("-----> *** MENSAGEM ENVIADA: ${jsonEncode(message)}\n");
      } else {
        log(
          "Não foi possível enviar a mensagem, pois a conexão está inativa!",
        );
      }
    } catch (e) {
      log("Erro ao enviar mensagem: $e");
    }
  }

  String get getUserPeer => _myPeer;

  void setUserPeer(String peer) => _myPeer = peer;

  @override
  void dispose() async {
    try {
      await _channel.sink.close(status.normalClosure, "Conexão encerrada");
      _channel.sink.close();
      _streamController.close();
      log("\t--##: CONEXÃO ENCERRADA!");
    } catch (e) {
      log("Erro ao encerrar sessão: $e");
    }
  }
}
