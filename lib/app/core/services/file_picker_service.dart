import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:file_picker/file_picker.dart';


@Injectable()
class FilePickerService extends Disposable {

  Future<void> getFile() async {
    FilePickerResult _filePickerResult;
    try {
      _filePickerResult = await FilePicker.platform.pickFiles();
      print(_filePickerResult.files.last.bytes);

    } on PlatformException catch(e) {
      print("Erro ao obter arquivo: $e");
    }
    return _filePickerResult;
  }
  //dispose will be called automatically
  @override
  void dispose() {}
}
