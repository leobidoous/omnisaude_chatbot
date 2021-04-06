import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:rx_notifier/rx_notifier.dart';

class UploadContentController extends Disposable {
  RxNotifier<Status> uploadStatus = RxNotifier(Status.NONE);

  @override
  void dispose() {
    uploadStatus.dispose();
  }
}
