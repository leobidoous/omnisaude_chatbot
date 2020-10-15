// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WebController on _WebControllerBase, Store {
  final _$botUsernameAtom = Atom(name: '_WebControllerBase.botUsername');

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

  final _$botTypingAtom = Atom(name: '_WebControllerBase.botTyping');

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

  final _$messagesAtom = Atom(name: '_WebControllerBase.messages');

  @override
  ObservableList<dynamic> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<dynamic> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$_onScrollListToBottomAsyncAction =
      AsyncAction('_WebControllerBase._onScrollListToBottom');

  @override
  Future<void> _onScrollListToBottom() {
    return _$_onScrollListToBottomAsyncAction
        .run(() => super._onScrollListToBottom());
  }

  final _$_onChangeChatGlobalConfigsAsyncAction =
      AsyncAction('_WebControllerBase._onChangeChatGlobalConfigs');

  @override
  Future<void> _onChangeChatGlobalConfigs(WsMessage message) {
    return _$_onChangeChatGlobalConfigsAsyncAction
        .run(() => super._onChangeChatGlobalConfigs(message));
  }

  @override
  String toString() {
    return '''
botUsername: ${botUsername},
botTyping: ${botTyping},
messages: ${messages}
    ''';
  }
}
