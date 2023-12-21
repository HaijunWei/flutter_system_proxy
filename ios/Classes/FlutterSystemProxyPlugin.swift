import Flutter
import UIKit

public class FlutterSystemProxyPlugin: NSObject, FlutterPlugin {
      public static func register(with registrar: FlutterPluginRegistrar) {
          let channel = FlutterMethodChannel(name: "com.haijunwei/flutter_system_proxy", binaryMessenger: registrar.messenger())
          let instance = FlutterSystemProxyPlugin()
          registrar.addMethodCallDelegate(instance, channel: channel)
      }

      public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          guard let proxiesSettings = getProxySettings() else {
              result(nil);
              return
          }
          switch call.method {
          case "getProxyHost":
              result(proxiesSettings["HTTPProxy"] as? String)
          case "getProxyPort":
              if let port = proxiesSettings["HTTPPort"] as? Int {
                  result(String(port))
              }
              result(nil)
          default:
            result(FlutterMethodNotImplemented)
          }
      }
    
    private func getProxySettings() -> [String : AnyObject]? {
          guard let proxiesSettingsUnmanaged = CFNetworkCopySystemProxySettings() else {
              return nil
          }
          guard let proxiesSettings = proxiesSettingsUnmanaged.takeRetainedValue() as? [String : AnyObject] else {
              return nil
          }
          
          return proxiesSettings
      }
}
