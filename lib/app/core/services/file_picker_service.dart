import 'dart:async';
import 'dart:html';

import 'package:flutter_modular/flutter_modular.dart';

@Injectable()
class FilePickerService extends Disposable {
  Future<List<String>> openFileStorage({String type: "*"}) async {
    final completer = new Completer<List<String>>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..multiple = true
      ..accept = '$type/*';
    input.onChange.listen(
      (e) async {
        final List<File> files = input.files;
        Iterable<Future<String>> resultsFutures = files.map(
          (file) {
            final reader = new FileReader();
            reader.readAsDataUrl(file);
            reader.onError.listen((error) => completer.completeError(error));
            return reader.onLoad.first.then((_) => reader.result as String);
          },
        );
        final results = await Future.wait(resultsFutures);
        completer.complete(results);
      },
    );
    input.click();
    return completer.future;
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
