// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_video_call_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AgoraVideoCallController on _AgoraVideoCallControllerBase, Store {
  final _$canInitCallAtom =
      Atom(name: '_AgoraVideoCallControllerBase.canInitCall');

  @override
  bool get canInitCall {
    _$canInitCallAtom.reportRead();
    return super.canInitCall;
  }

  @override
  set canInitCall(bool value) {
    _$canInitCallAtom.reportWrite(value, super.canInitCall, () {
      super.canInitCall = value;
    });
  }

  final _$hasCameraPermissionAtom =
      Atom(name: '_AgoraVideoCallControllerBase.hasCameraPermission');

  @override
  bool get hasCameraPermission {
    _$hasCameraPermissionAtom.reportRead();
    return super.hasCameraPermission;
  }

  @override
  set hasCameraPermission(bool value) {
    _$hasCameraPermissionAtom.reportWrite(value, super.hasCameraPermission, () {
      super.hasCameraPermission = value;
    });
  }

  final _$hasMicrophonePermissionAtom =
      Atom(name: '_AgoraVideoCallControllerBase.hasMicrophonePermission');

  @override
  bool get hasMicrophonePermission {
    _$hasMicrophonePermissionAtom.reportRead();
    return super.hasMicrophonePermission;
  }

  @override
  set hasMicrophonePermission(bool value) {
    _$hasMicrophonePermissionAtom
        .reportWrite(value, super.hasMicrophonePermission, () {
      super.hasMicrophonePermission = value;
    });
  }

  final _$hasStorePermissionAtom =
      Atom(name: '_AgoraVideoCallControllerBase.hasStorePermission');

  @override
  bool get hasStorePermission {
    _$hasStorePermissionAtom.reportRead();
    return super.hasStorePermission;
  }

  @override
  set hasStorePermission(bool value) {
    _$hasStorePermissionAtom.reportWrite(value, super.hasStorePermission, () {
      super.hasStorePermission = value;
    });
  }

  @override
  String toString() {
    return '''
canInitCall: ${canInitCall},
hasCameraPermission: ${hasCameraPermission},
hasMicrophonePermission: ${hasMicrophonePermission},
hasStorePermission: ${hasStorePermission}
    ''';
  }
}
