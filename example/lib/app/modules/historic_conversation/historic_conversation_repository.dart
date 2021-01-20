import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot_example/app/core/custom_dio/dio_interceptor.dart';


@Injectable()
class HistoricConversationRepository extends Disposable {
  Dio _dio;

  HistoricConversationRepository() {
    _dio = Dio();
    _dio.options.baseUrl = BASE_URL + DEFAULT_API;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.interceptors.add(DioInterceptors());
  }

  Future<dynamic> getHistoricConversation(
      {String sessionId, String token}) async {
    try {
      _dio.options.headers.addAll({"Authorization": "JWT $token"});
      Response _response = await _dio.get("/conversation/$sessionId/");
      return _response.data.map((m) => WsMessage.fromJson(m)).toList();
    } on DioError catch (e) {
      print("getHistoricConversation: $e");
      throw e;
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
