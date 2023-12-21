import 'dart:io';

import 'flutter_system_proxy_platform_interface.dart';

class FlutterSystemProxy {
  static Future<String?> getProxyHost() {
    return FlutterSystemProxyPlatform.instance.getProxyHost();
  }

  static Future<String?> getProxyPort() {
    return FlutterSystemProxyPlatform.instance.getProxyPort();
  }
}

class HttpProxyOverride extends HttpOverrides {
  late final String? host;
  late final String? port;

  HttpProxyOverride._(this.host, this.port);

  static Future<HttpProxyOverride> createHttpProxy() async {
    return HttpProxyOverride._(await FlutterSystemProxy.getProxyHost(),
        await FlutterSystemProxy.getProxyPort());
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    var client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
    return client;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (host == null) {
      return super.findProxyFromEnvironment(url, environment);
    }

    environment ??= {};

    if (port != null) {
      environment['http_proxy'] = '$host:$port';
      environment['https_proxy'] = '$host:$port';
    } else {
      environment['http_proxy'] = '$host:8888';
      environment['https_proxy'] = '$host:8888';
    }

    return super.findProxyFromEnvironment(url, environment);
  }
}
