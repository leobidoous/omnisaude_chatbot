import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'success_controller.g.dart';

@Injectable()
class SuccessController = _SuccessControllerBase with _$SuccessController;

abstract class _SuccessControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
