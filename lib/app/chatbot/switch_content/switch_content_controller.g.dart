// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_content_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SwitchContentController on _SwitchContentControllerBase, Store {
  final _$selectedOptionsAtom =
      Atom(name: '_SwitchContentControllerBase.selectedOptions');

  @override
  ObservableList<Option> get selectedOptions {
    _$selectedOptionsAtom.reportRead();
    return super.selectedOptions;
  }

  @override
  set selectedOptions(ObservableList<Option> value) {
    _$selectedOptionsAtom.reportWrite(value, super.selectedOptions, () {
      super.selectedOptions = value;
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

  final _$filteredOptionsAtom =
      Atom(name: '_SwitchContentControllerBase.filteredOptions');

  @override
  ObservableList<Option> get filteredOptions {
    _$filteredOptionsAtom.reportRead();
    return super.filteredOptions;
  }

  @override
  set filteredOptions(ObservableList<Option> value) {
    _$filteredOptionsAtom.reportWrite(value, super.filteredOptions, () {
      super.filteredOptions = value;
    });
  }

  final _$onSendOptionsMessageAsyncAction =
      AsyncAction('_SwitchContentControllerBase.onSendOptionsMessage');

  @override
  Future<void> onSendOptionsMessage(Connection connection) {
    return _$onSendOptionsMessageAsyncAction
        .run(() => super.onSendOptionsMessage(connection));
  }

  final _$onSearchIntoOptionsAsyncAction =
      AsyncAction('_SwitchContentControllerBase.onSearchIntoOptions');

  @override
  Future<void> onSearchIntoOptions(List<Option> options, String filter) {
    return _$onSearchIntoOptionsAsyncAction
        .run(() => super.onSearchIntoOptions(options, filter));
  }

  @override
  String toString() {
    return '''
selectedOptions: ${selectedOptions},
searchOptions: ${searchOptions},
filteredOptions: ${filteredOptions}
    ''';
  }
}
