// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$chatBotsAtom = Atom(name: '_HomeControllerBase.chatBots');

  @override
  dynamic get chatBots {
    _$chatBotsAtom.reportRead();
    return super.chatBots;
  }

  @override
  set chatBots(dynamic value) {
    _$chatBotsAtom.reportWrite(value, super.chatBots, () {
      super.chatBots = value;
    });
  }

  final _$chatSelectedAtom = Atom(name: '_HomeControllerBase.chatSelected');

  @override
  dynamic get chatSelected {
    _$chatSelectedAtom.reportRead();
    return super.chatSelected;
  }

  @override
  set chatSelected(dynamic value) {
    _$chatSelectedAtom.reportWrite(value, super.chatSelected, () {
      super.chatSelected = value;
    });
  }

  final _$onGetChatBotsAsyncAction =
      AsyncAction('_HomeControllerBase.onGetChatBots');

  @override
  Future<void> onGetChatBots() {
    return _$onGetChatBotsAsyncAction.run(() => super.onGetChatBots());
  }

  @override
  String toString() {
    return '''
chatBots: ${chatBots},
chatSelected: ${chatSelected}
    ''';
  }
}
