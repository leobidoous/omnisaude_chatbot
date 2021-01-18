import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'empty_controller.g.dart';

@Injectable()
class EmptyController = _EmptyControllerBase with _$EmptyController;

abstract class _EmptyControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
