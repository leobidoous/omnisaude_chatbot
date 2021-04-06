import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:share/share.dart';

class ShareFile extends Disposable {
  Future<void> file(BuildContext context, File file, {String filename}) async {
    final String _filename = filename ?? basename(file.path);
    final RenderBox _box = context.findRenderObject();
    await Share.shareFiles(
      [file.path],
      subject: _filename,
      text: "Compartilhar documento",
      mimeTypes: [lookupMimeType(file.path)],
      sharePositionOrigin: _box.localToGlobal(Offset(0, -10)) & _box.size,
    );
  }

  @override
  void dispose() {}
}
