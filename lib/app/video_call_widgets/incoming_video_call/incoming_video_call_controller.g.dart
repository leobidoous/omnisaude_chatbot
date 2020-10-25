// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_video_call_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IncomingVideoCallController on _IncomingVideoCallControllerBase, Store {
  final _$cameraControllerAtom =
      Atom(name: '_IncomingVideoCallControllerBase.cameraController');

  @override
  CameraController get cameraController {
    _$cameraControllerAtom.reportRead();
    return super.cameraController;
  }

  @override
  set cameraController(CameraController value) {
    _$cameraControllerAtom.reportWrite(value, super.cameraController, () {
      super.cameraController = value;
    });
  }

  @override
  String toString() {
    return '''
cameraController: ${cameraController}
    ''';
  }
}
