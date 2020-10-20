import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot_example/app/core/models/bots_model.dart';
import 'package:omnisaude_chatbot_example/app/modules/home/home_repository.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  @observable
  dynamic chatBots = Result()..results = List<ChatBot>();
  @observable
  dynamic chatSelected;

  @action
  Future<void> onGetChatBots() async {
    try {
      final HomeRepository _repository = HomeRepository();
      chatBots = await _repository.onGetChatBots();
    } on DioError catch(e) {
    }
  }
}
