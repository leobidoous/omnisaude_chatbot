import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'image_controller.g.dart';

@Injectable()
class ImageController = _ImageControllerBase with _$ImageController;

abstract class _ImageControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
