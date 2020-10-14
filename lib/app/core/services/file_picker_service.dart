import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

@Injectable()
class FilePickerService extends Disposable {
  final ImagePicker _picker = ImagePicker();

  Future<void> openFileStorage() async {
    FilePickerResult _filePickerResult;
    try {
      _filePickerResult = await FilePicker.platform.pickFiles();
      print(_filePickerResult.files.last.bytes);
    } on PlatformException catch (e) {
      print("Erro ao obter arquivo: $e");
    }
    return _filePickerResult;
  }

  Future<File> openCamera() async {
    PickedFile _pickedFile;
    try {
      _pickedFile = await _picker.getImage(source: ImageSource.camera);
      if (_pickedFile?.path == null) return null;
      return File(_pickedFile.path);
    } on PlatformException catch (e) {
      print("Erro ao obter arquivo da galeria: $e");
      return null;
    }
  }

  Future<File> openGalery() async {
    PickedFile _pickedFile;
    try {
      _pickedFile = await _picker.getImage(source: ImageSource.gallery);
      if (_pickedFile?.path == null) return null;
      return File(_pickedFile.path);
    } on PlatformException catch (e) {
      print("Erro ao obter arquivo da galeria: $e");
      return null;
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
