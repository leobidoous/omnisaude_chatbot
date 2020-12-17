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

  final _$hasVideoPermissionAtom =
      Atom(name: '_AgoraVideoCallControllerBase.hasVideoPermission');

  @override
  bool get hasVideoPermission {
    _$hasVideoPermissionAtom.reportRead();
    return super.hasVideoPermission;
  }

  @override
  set hasVideoPermission(bool value) {
    _$hasVideoPermissionAtom.reportWrite(value, super.hasVideoPermission, () {
      super.hasVideoPermission = value;
    });
  }

  final _$hasAudioPermissionAtom =
      Atom(name: '_AgoraVideoCallControllerBase.hasAudioPermission');

  @override
  bool get hasAudioPermission {
    _$hasAudioPermissionAtom.reportRead();
    return super.hasAudioPermission;
  }

  @override
  set hasAudioPermission(bool value) {
    _$hasAudioPermissionAtom.reportWrite(value, super.hasAudioPermission, () {
      super.hasAudioPermission = value;
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

  final _$switchVideosAtom =
      Atom(name: '_AgoraVideoCallControllerBase.switchVideos');

  @override
  bool get switchVideos {
    _$switchVideosAtom.reportRead();
    return super.switchVideos;
  }

  @override
  set switchVideos(bool value) {
    _$switchVideosAtom.reportWrite(value, super.switchVideos, () {
      super.switchVideos = value;
    });
  }

  final _$videoEnabledAtom =
      Atom(name: '_AgoraVideoCallControllerBase.videoEnabled');

  @override
  bool get videoEnabled {
    _$videoEnabledAtom.reportRead();
    return super.videoEnabled;
  }

  @override
  set videoEnabled(bool value) {
    _$videoEnabledAtom.reportWrite(value, super.videoEnabled, () {
      super.videoEnabled = value;
    });
  }

  final _$audioEnabledAtom =
      Atom(name: '_AgoraVideoCallControllerBase.audioEnabled');

  @override
  bool get audioEnabled {
    _$audioEnabledAtom.reportRead();
    return super.audioEnabled;
  }

  @override
  set audioEnabled(bool value) {
    _$audioEnabledAtom.reportWrite(value, super.audioEnabled, () {
      super.audioEnabled = value;
    });
  }

  final _$cameraTypeAtom =
      Atom(name: '_AgoraVideoCallControllerBase.cameraType');

  @override
  CameraType get cameraType {
    _$cameraTypeAtom.reportRead();
    return super.cameraType;
  }

  @override
  set cameraType(CameraType value) {
    _$cameraTypeAtom.reportWrite(value, super.cameraType, () {
      super.cameraType = value;
    });
  }

  final _$fullScreenAtom =
      Atom(name: '_AgoraVideoCallControllerBase.fullScreen');

  @override
  bool get fullScreen {
    _$fullScreenAtom.reportRead();
    return super.fullScreen;
  }

  @override
  set fullScreen(bool value) {
    _$fullScreenAtom.reportWrite(value, super.fullScreen, () {
      super.fullScreen = value;
    });
  }

  final _$insideVideoAlignmentAtom =
      Atom(name: '_AgoraVideoCallControllerBase.insideVideoAlignment');

  @override
  Alignment get insideVideoAlignment {
    _$insideVideoAlignmentAtom.reportRead();
    return super.insideVideoAlignment;
  }

  @override
  set insideVideoAlignment(Alignment value) {
    _$insideVideoAlignmentAtom.reportWrite(value, super.insideVideoAlignment,
        () {
      super.insideVideoAlignment = value;
    });
  }

  @override
  String toString() {
    return '''
canInitCall: ${canInitCall},
hasVideoPermission: ${hasVideoPermission},
hasAudioPermission: ${hasAudioPermission},
hasStorePermission: ${hasStorePermission},
switchVideos: ${switchVideos},
videoEnabled: ${videoEnabled},
audioEnabled: ${audioEnabled},
cameraType: ${cameraType},
fullScreen: ${fullScreen},
insideVideoAlignment: ${insideVideoAlignment}
    ''';
  }
}
