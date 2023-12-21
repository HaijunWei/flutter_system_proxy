import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_system_proxy_platform_interface.dart';

/// An implementation of [FlutterSystemProxyPlatform] that uses method channels.
class MethodChannelFlutterSystemProxy extends FlutterSystemProxyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('com.haijunwei/flutter_system_proxy');

  @override
  Future<String?> getProxyHost() async {
    return methodChannel.invokeMethod<String?>('getProxyHost');
  }

  @override
  Future<String?> getProxyPort() async {
    return methodChannel.invokeMethod<String?>('getProxyPort');
  }
}
