import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PathUtils {
  Future<String> get localPath async {
    await Permission.mediaLibrary.request();
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get tempPath async {
    await Permission.mediaLibrary.request();
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> getFileFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load(path);
      final file = File('${await localPath}/$path');
      file.writeAsBytesSync(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      return file;
    } catch (e) {
      print("getFileFromAssets: $e");
      return null;
    }
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      HttpClientRequest _request = await HttpClient().getUrl(Uri.parse(url));
      HttpClientResponse _response = await _request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(_response);
      final String _ext = url.split('.').last;
      final String _name = Uuid().v1();
      File _file = new File('${await localPath}/$_name.$_ext');
      await _file.writeAsBytes(bytes);
      return _file;
    } catch (e) {
      print("getFileFromUrl: $e");
      return null;
    }
  }
}
