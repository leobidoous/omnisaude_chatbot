import Flutter
import UIKit

public class SwiftOmnisaudeChatbotPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "omnisaude_chatbot", binaryMessenger: registrar.messenger())
    let instance = SwiftOmnisaudeChatbotPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
