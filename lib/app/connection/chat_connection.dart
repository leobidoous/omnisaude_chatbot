import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/enums/enums.dart';
import '../core/models/ws_message_model.dart';

class ChatConnection extends Disposable {
  final String url;
  final String username;
  final String avatarUrl;
  String _myPeer;

  ChatConnection({this.url, this.username, this.avatarUrl});

  final StreamController<WsMessage> _streamController = new StreamController();
  StreamSubscription _streamSubscription;
  ConnectionStatus connectionStatus = ConnectionStatus.NONE;
  WebSocketChannel _channel;

  Future<StreamController> onInitSession() async {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    connectionStatus = ConnectionStatus.WAITING;
    _streamSubscription = _channel.stream.listen(
          (onMessage) async {
        _streamSubscription.pause();
        connectionStatus = ConnectionStatus.ACTIVE;
        final WsMessage _message = WsMessage.fromJson(jsonDecode(onMessage));
        if (_message.eventContent?.eventType == EventType.CONNECTED) {
          setUserPeer(_message.eventContent.message);
        }
        _streamController.sink.add(_message);
        _onMessageReceived(_message);
        await Future.delayed(Duration(milliseconds: 100));
        _streamSubscription.resume();
      },
      onError: (onError) {
        log("Erro de conexão: $onError");
        connectionStatus = ConnectionStatus.ERROR;
        _streamController.addError(onError);
      },
      onDone: () {
        log("Conexão encerrada!");
        connectionStatus = ConnectionStatus.DONE;
        _streamController?.close();
      },
    );
    return _streamController;
  }

  void _onMessageReceived(WsMessage message) {
    try {
      log("###--> MENSAGEM RECEBIDA: ${message.toJson()}\n");
    } catch (e) {
      log("Erro ao receber mensagem: $e");
    }
  }

  Future<void> onSendMessage(WsMessage message) async {
    try {
      message.username = username;
      message.avatarUrl = avatarUrl;
      message.peer = _myPeer;
      message.datetime = DateTime.now().toIso8601String();

      if (connectionStatus == ConnectionStatus.ACTIVE) {
        _channel.sink.add(jsonEncode(message));
        log("***--> MENSAGEM ENVIADA: ${jsonEncode(message)}\n");
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
      _streamController?.close();
      await _streamSubscription?.cancel();
      log("--##: CONEXÃO ENCERRADA!");
    } catch (e) {
      log("Erro ao encerrar sessão: $e");
    }
  }
}
