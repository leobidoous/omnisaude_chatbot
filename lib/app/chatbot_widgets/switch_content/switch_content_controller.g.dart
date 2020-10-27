// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_content_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SwitchContentController on _SwitchContentControllerBase, Store {
  final _$optionsSelectedAtom =
      Atom(name: '_SwitchContentControllerBase.optionsSelected');

  @override
  ObservableList<Option> get optionsSelecteds {
    _$optionsSelectedAtom.reportRead();
    return super.optionsSelecteds;
  }

  @override
  set optionsSelecteds(ObservableList<Option> value) {
    _$optionsSelectedAtom.reportWrite(value, super.optionsSelecteds, () {
      super.optionsSelecteds = value;
    });
  }

  final _$searchOptionsAtom =
      Atom(name: '_SwitchContentControllerBase.searchOptions');

  @override
  ObservableList<Option> get searchOptions {
    _$searchOptionsAtom.reportRead();
    return super.searchOptions;
  }

  @override
  set searchOptions(ObservableList<Option> value) {
    _$searchOptionsAtom.reportWrite(value, super.searchOptions, () {
      super.searchOptions = value;
    });
  }

  final _$onSendOptionsMessageAsyncAction =
      AsyncAction('_SwitchContentControllerBase.onSendOptionsMessage');

  @override
  Future<void> onSendOptionsMessage(Connection connection) {
    return _$onSendOptionsMessageAsyncAction
        .run(() => super.onSendOptionsMessage(connection));
  }

  @override
  String toString() {
    return '''
optionsSelected: ${optionsSelecteds},
searchOptions: ${searchOptions}
    ''';
  }
}
