import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_system_proxy_method_channel.dart';

abstract class FlutterSystemProxyPlatform extends PlatformInterface {
  /// Constructs a FlutterSystemProxyPlatform.
  FlutterSystemProxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSystemProxyPlatform _instance =
      MethodChannelFlutterSystemProxy();

  /// The default instance of [FlutterSystemProxyPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSystemProxy].
  static FlutterSystemProxyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSystemProxyPlatform] when
  /// they register themselves.
  static set instance(FlutterSystemProxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getProxyHost() {
    throw UnimplementedError('getProxyHost() has not been implemented.');
  }

  Future<String?> getProxyPort() {
    throw UnimplementedError('getProxyPort() has not been implemented.');
  }
}
