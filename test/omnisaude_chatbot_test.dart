import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omnisaude_chatbot/omnisaude_chatbot.dart';

void main() {
  const MethodChannel channel = MethodChannel('omnisaude_chatbot');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OmnisaudeChatbot.platformVersion, '42');
  });
}
