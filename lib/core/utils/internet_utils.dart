import 'package:connectivity_plus/connectivity_plus.dart';

class InternetUtils {
  static bool _hasLink(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return _hasLink(result);
  }

  /// WiFi / mobile data on hai. DNS lookup nahi — wo false "no internet" deta hai.
  static Future<bool> hasInternetAccess() => isConnected();

  static Future<bool> isInternetAvailable() => isConnected();
}
