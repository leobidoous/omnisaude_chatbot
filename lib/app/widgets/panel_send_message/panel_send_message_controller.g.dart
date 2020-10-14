// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_send_message_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PanelSendMessageController on _PanelSendMessageControllerBase, Store {
  final _$inputEnabledAtom =
      Atom(name: '_PanelSendMessageControllerBase.inputEnabled');

  @override
  bool get inputEnabled {
    _$inputEnabledAtom.reportRead();
    return super.inputEnabled;
  }

  @override
  set inputEnabled(bool value) {
    _$inputEnabledAtom.reportWrite(value, super.inputEnabled, () {
      super.inputEnabled = value;
    });
  }

  final _$attachEnabledAtom =
      Atom(name: '_PanelSendMessageControllerBase.attachEnabled');

  @override
  bool get attachEnabled {
    _$attachEnabledAtom.reportRead();
    return super.attachEnabled;
  }

  @override
  set attachEnabled(bool value) {
    _$attachEnabledAtom.reportWrite(value, super.attachEnabled, () {
      super.attachEnabled = value;
    });
  }

  final _$dateEnabledAtom =
      Atom(name: '_PanelSendMessageControllerBase.dateEnabled');

  @override
  bool get dateEnabled {
    _$dateEnabledAtom.reportRead();
    return super.dateEnabled;
  }

  @override
  set dateEnabled(bool value) {
    _$dateEnabledAtom.reportWrite(value, super.dateEnabled, () {
      super.dateEnabled = value;
    });
  }

  final _$textEnabledAtom =
      Atom(name: '_PanelSendMessageControllerBase.textEnabled');

  @override
  bool get textEnabled {
    _$textEnabledAtom.reportRead();
    return super.textEnabled;
  }

  @override
  set textEnabled(bool value) {
    _$textEnabledAtom.reportWrite(value, super.textEnabled, () {
      super.textEnabled = value;
    });
  }

  @override
  String toString() {
    return '''
inputEnabled: ${inputEnabled},
attachEnabled: ${attachEnabled},
dateEnabled: ${dateEnabled},
textEnabled: ${textEnabled}
    ''';
  }
}
