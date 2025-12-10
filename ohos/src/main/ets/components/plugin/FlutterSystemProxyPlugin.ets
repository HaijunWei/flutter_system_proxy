import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import connection from '@ohos.net.connection';

/** FlutterSystemProxyPlugin **/
export default class FlutterSystemProxyPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "FlutterSystemProxyPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "com.haijunwei/flutter_system_proxy");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getProxyHost") {
      this.getProxyHost().then((host: string | null) => {
        result.success(host);
      }).catch((error: Error) => {
        result.success(null);
      });
    } else if (call.method == "getProxyPort") {
      this.getProxyPort().then((port: string | null) => {
        result.success(port);
      }).catch((error: Error) => {
        result.success(null);
      });
    } else {
      result.notImplemented()
    }
  }

  /**
   * 获取系统默认 HTTP 代理信息
   * 参考文档: https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-net-connection-V5#connectiongetdefaulthttpproxy10
   */
  private async getProxyInfo(): Promise<connection.HttpProxy | null> {
    try {
      const proxyInfo = await connection.getDefaultHttpProxy();
      return proxyInfo;
    } catch (error) {
      console.error("Error getting proxy info:", error);
      return null;
    }
  }

  private async getProxyHost(): Promise<string | null> {
    const proxyInfo = await this.getProxyInfo();
    if (proxyInfo && proxyInfo.host) {
      return proxyInfo.host;
    }
    return null;
  }

  private async getProxyPort(): Promise<string | null> {
    const proxyInfo = await this.getProxyInfo();
    if (proxyInfo && proxyInfo.port !== undefined && proxyInfo.port !== null) {
      return String(proxyInfo.port);
    }
    return null;
  }
}