// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_call_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IncomingCallController on _IncomingCallControllerBase, Store {
  final _$valueAtom = Atom(name: '_IncomingCallControllerBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$_IncomingCallControllerBaseActionController =
      ActionController(name: '_IncomingCallControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_IncomingCallControllerBaseActionController
        .startAction(name: '_IncomingCallControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_IncomingCallControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
