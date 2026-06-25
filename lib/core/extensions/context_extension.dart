import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
}
