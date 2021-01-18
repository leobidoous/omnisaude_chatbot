import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerService extends Disposable {
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> openFileStorage() async {
    FilePickerResult _filePickerResult;
    try {
      _filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      if (_filePickerResult == null) return null;
      if (_filePickerResult.files.isEmpty) return null;
      return _filePickerResult.files.map((e) => File(e.path)).toList();
    } on PlatformException catch (e) {
      log("Erro ao obter arquivo: $e");
      return null;
    }
  }

  Future<File> openCamera() async {
    PickedFile _pickedFile;
    try {
      _pickedFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (_pickedFile?.path == null) return null;
      return File(_pickedFile.path);
    } on PlatformException catch (e) {
      log("Erro ao obter arquivo da galeria: $e");
      return null;
    }
  }

  Future<File> openGallery() async {
    PickedFile _pickedFile;
    try {
      _pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (_pickedFile?.path == null) return null;
      return File(_pickedFile.path);
    } on PlatformException catch (e) {
      log("Erro ao obter arquivo da galeria: $e");
      return null;
    }
  }

  Future<File> onCropImage(File file) async {
    final List<CropAspectRatioPreset> _android = [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ];

    final List<CropAspectRatioPreset> _iOS = [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9,
    ];

    return await ImageCropper.cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: Platform.isIOS ? _iOS : _android,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Editar imagem',
        showCancelConfirmationDialog: true,
      ),
    );
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
