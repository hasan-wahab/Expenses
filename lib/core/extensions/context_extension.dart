import 'package:app_settings/app_settings.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

extension ContextExtension on BuildContext {
  /// Screen Height And Width
  double get sw => MediaQuery.of(this).size.width;
  double get sh => MediaQuery.of(this).size.height;

  /// Text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Default body icon (teal)
  Color get iconColor => Theme.of(this).iconTheme.color ?? colors.tertiary;

  /// Selected / action / accent icon (primary)
  Color get iconAccent => colors.primary;

  /// Back / unselected nav icon
  Color get iconMuted => colors.onSurfaceVariant;

  /// Icon on primary fill
  Color get iconOnPrimary => colors.onPrimary;

  /// Delete / error icon
  Color get iconError => colors.error;

  /// AppBar Text Style
  TextStyle? get appBarTextStyle => textTheme.headlineSmall;

  /// Body Text Style

  TextStyle? get extraLarge => textTheme.headlineLarge;
  TextStyle? get primaryText => textTheme.titleLarge;
  TextStyle? get secondaryText => textTheme.titleMedium;
  TextStyle? get smallText => textTheme.bodyLarge;
  TextStyle? get extraSmallText => textTheme.bodySmall;

  /// Snack bar
  void showSnackBar(
    String message, {
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError ? AppColors.redColor : AppColors.primary,
          closeIconColor: AppColors.redColor,
          content: Text(message),
          behavior: snackBarBehavior,
        ),
      );
  }

  Future<void> showConfirmationDialog({
    VoidCallback? onYesPressed,
    String title = "Confirmation",
    String message = "Are you sure?",
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: SecondaryText(text: title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SmallText(text: message, maxLine: 3),
              const SizedBox(height: 20),

              /// ✅ Buttons Row (full width)
              Row(
                spacing: 20.w,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      height: 35.h,
                      isOutline: true,
                      onTap: () {
                        pop();
                      },
                      text: 'Cancel',
                    ),
                  ),
                  Expanded(
                    child: PrimaryButton(
                      height: 35.h,
                      onTap: () {
                        pop();
                        onYesPressed?.call();
                      },
                      text: "Yes",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Loading dialog (login / create account)
  static const String _loadingRouteName = 'app_loading_dialog';

  void showCustomLoading() {
    showDialog<void>(
      context: this,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: _loadingRouteName),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Loading...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void hideCustomLoading() {
    Navigator.of(this, rootNavigator: true).popUntil((route) {
      return route.settings.name != _loadingRouteName;
    });
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

  Future<DateTime?> showAppDatePicker() async {
    return await showDatePicker(
      context: this,

      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<ImageSource?> showImageSourcePicker() {
    return showModalBottomSheet<ImageSource>(
      context: this,
      backgroundColor: AppColors.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 16.h),
                SecondaryText(text: 'Choose Image Source'),
                SizedBox(height: 16.h),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: context.iconAccent,
                  ),
                  title: SmallText(text: 'Gallery'),
                  onTap: () => pop(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: context.iconAccent,
                  ),
                  title: SmallText(text: 'Camera'),
                  onTap: () => pop(ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
