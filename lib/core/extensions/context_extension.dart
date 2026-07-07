import 'package:app_settings/app_settings.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  /// Screen Height And Width
  double get sw => MediaQuery.of(this).size.width;
  double get sh => MediaQuery.of(this).size.height;

  /// Text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// AppBar Text Style
  TextStyle? get appBarTextStyle => textTheme.headlineSmall;

  /// Body Text Style

  TextStyle? get extraLarge => textTheme.headlineLarge;
  TextStyle? get primaryText => textTheme.titleLarge;
  TextStyle? get secondaryText => textTheme.titleMedium;
  TextStyle? get smallText => textTheme.bodyLarge;
  TextStyle? get extraSmallText => textTheme.bodySmall;

  /// Snack bar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          closeIconColor: AppColors.redColor,
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// Loading dialog
  void showCustomLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  /// App settings

  void appSettings({
    required AppSettingsType type,
    required String title,
    required String message,
  }) {
    showDialog(
      context: this,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              pop();
              AppSettings.openAppSettings(type: type);
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
