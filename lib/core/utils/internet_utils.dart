import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetUtils {
  /// Check network (WiFi / Mobile Data)
  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();

    return result != ConnectivityResult.none;
  }

  /// Real internet check (recommended)
  static Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Combined check (BEST for apps)
  static Future<bool> isInternetAvailable() async {
    final network = await isConnected();
    if (!network) return false;

    final realInternet = await hasInternetAccess();
    return realInternet;
  }
}
