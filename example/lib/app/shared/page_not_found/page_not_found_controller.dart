import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'page_not_found_controller.g.dart';

@Injectable()
class PageNotFoundController = _PageNotFoundControllerBase
    with _$PageNotFoundController;

abstract class _PageNotFoundControllerBase with Store {
}
