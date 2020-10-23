// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AvatarController on _AvatarControllerBase, Store {
  final _$valueAtom = Atom(name: '_AvatarControllerBase.value');

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

  final _$_AvatarControllerBaseActionController =
      ActionController(name: '_AvatarControllerBase');

  @override
  void increment() {
    final _$actionInfo = _$_AvatarControllerBaseActionController.startAction(
        name: '_AvatarControllerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_AvatarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
