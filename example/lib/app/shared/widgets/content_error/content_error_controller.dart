import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'content_error_controller.g.dart';

@Injectable()
class ContentErrorController = _ContentErrorControllerBase
    with _$ContentErrorController;

abstract class _ContentErrorControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
