import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'upload_content_controller.g.dart';

@Injectable()
class UploadContentController = _UploadContentControllerBase
    with _$UploadContentController;

abstract class _UploadContentControllerBase with Store {
  @observable
  String a;
}
