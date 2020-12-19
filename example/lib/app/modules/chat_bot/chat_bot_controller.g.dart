// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_bot_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatBotController on _ChatBotControllerBase, Store {
  final _$connectionStatusAtom =
      Atom(name: '_ChatBotControllerBase.connectionStatus');

  @override
  ConnectionStatus get connectionStatus {
    _$connectionStatusAtom.reportRead();
    return super.connectionStatus;
  }

  @override
  set connectionStatus(ConnectionStatus value) {
    _$connectionStatusAtom.reportWrite(value, super.connectionStatus, () {
      super.connectionStatus = value;
    });
  }

  final _$botUsernameAtom = Atom(name: '_ChatBotControllerBase.botUsername');

  @override
  String get botUsername {
    _$botUsernameAtom.reportRead();
    return super.botUsername;
  }

  @override
  set botUsername(String value) {
    _$botUsernameAtom.reportWrite(value, super.botUsername, () {
      super.botUsername = value;
    });
  }

  final _$botTypingAtom = Atom(name: '_ChatBotControllerBase.botTyping');

  @override
  bool get botTyping {
    _$botTypingAtom.reportRead();
    return super.botTyping;
  }

  @override
  set botTyping(bool value) {
    _$botTypingAtom.reportWrite(value, super.botTyping, () {
      super.botTyping = value;
    });
  }

  final _$messagesAtom = Atom(name: '_ChatBotControllerBase.messages');

  @override
  ObservableList<WsMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<WsMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$onScrollListToBottomAsyncAction =
      AsyncAction('_ChatBotControllerBase.onScrollListToBottom');

  @override
  Future<void> onScrollListToBottom() {
    return _$onScrollListToBottomAsyncAction
        .run(() => super.onScrollListToBottom());
  }

  final _$_onChangeChatGlobalConfigsAsyncAction =
      AsyncAction('_ChatBotControllerBase._onChangeChatGlobalConfigs');

  @override
  Future<void> _onChangeChatGlobalConfigs(WsMessage message) {
    return _$_onChangeChatGlobalConfigsAsyncAction
        .run(() => super._onChangeChatGlobalConfigs(message));
  }

  @override
  String toString() {
    return '''
connectionStatus: ${connectionStatus},
botUsername: ${botUsername},
botTyping: ${botTyping},
messages: ${messages}
    ''';
  }
}
