import 'dart:async';

import 'package:flutter/services.dart';

class OmnisaudeChatbot {
  static const MethodChannel _channel =
      const MethodChannel('omnisaude_chatbot');

  static Future<String> get platformVersion async {
    String _version;
    try{
      return await _channel.invokeMethod('getPlatformVersion');
    } catch(e) {
      return _version;
    }
  }
}
