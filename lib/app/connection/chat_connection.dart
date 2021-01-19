import 'dart:async';
import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatConnection extends Disposable {
  final String url;
  final String username;
  final String avatarUrl;
  String _myPeer;

  ChatConnection({this.url, this.username, this.avatarUrl});

  final StreamController<WsMessage> _streamController = StreamController();
  ConnectionStatus connectionStatus = ConnectionStatus.NONE;
  WebSocketChannel _channel;

  Future<StreamController> onInitSession() async {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    connectionStatus = ConnectionStatus.WAITING;
    _channel.stream.listen(
      (event) {
        connectionStatus = ConnectionStatus.ACTIVE;
        final WsMessage _message = WsMessage.fromJson(jsonDecode(event));
        if (_message.eventContent?.eventType == EventType.CONNECTED) {
          setUserPeer(_message.eventContent.message);
        }
        _onMessageReceived(_message);
        _streamController.add(_message);
      },
      onError: (onError) async {
        print("Erro de conexão: $onError");
        connectionStatus = ConnectionStatus.ERROR;
        _streamController.addError(onError);
        await _onCloseSession();
      },
      onDone: () async {
        print("Conexão encerrada!");
        connectionStatus = ConnectionStatus.DONE;
      },
    );
    return _streamController;
  }

  Future<void> _onMessageReceived(WsMessage message) async {
    try {
      print("-----> ### MENSAGEM RECEBIDA: ${message.toJson()}\n");
    } catch (e) {
      print("Erro ao receber mensagem: $e");
    }
  }

  Future<void> onSendMessage(WsMessage message) async {
    try {
      message.username = username;
      message.avatarUrl = avatarUrl;

      if (connectionStatus == ConnectionStatus.ACTIVE) {
        _channel.sink.add(jsonEncode(message));
        print("-----> *** MENSAGEM ENVIADA: ${message.toJson()}\n");
      } else {
        print(
          "Não foi possível enviar a mensagem, pois a conexão está inativa!",
        );
      }
    } catch (e) {
      print("Erro ao enviar mensagem: $e");
    }
  }

  String get getUserPeer => _myPeer;

  void setUserPeer(String peer) => _myPeer = peer;

  Future<void> _onCloseSession() async {
    try {
      await _channel.sink.close(status.normalClosure, "Conexão encerrada");
      _channel.sink.close();
      _streamController.close();
      print("\t--##: CONEXÃO ENCERRADA!");
    } catch (e) {
      print("Erro ao encerrar sessão: $e");
    }
  }

  @override
  void dispose() async {
    await _onCloseSession();
  }
}
