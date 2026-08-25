import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.white,
      tertiary: AppColors.iconsColor,
      onTertiary: AppColors.white,
      error: AppColors.redColor,
      onError: AppColors.white,
      surface: AppColors.bgColor,
      onSurface: AppColors.textBlack,
      onSurfaceVariant: AppColors.iconsBlackColor,
      outline: AppColors.secondaryTColor,
      shadow: AppColors.shadowColor,
    );

    final defaultIconTheme = IconThemeData(
      size: 22.r,
      color: AppColors.iconsColor,
    );

    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgColor,
      fontFamily: 'Inter',
      iconTheme: defaultIconTheme,
      primaryIconTheme: IconThemeData(size: 22.r, color: AppColors.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgColor,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        iconTheme: IconThemeData(
          size: 22.r,
          color: AppColors.iconsBlackColor,
        ),
        actionsIconTheme: IconThemeData(
          size: 22.r,
          color: AppColors.primary,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.iconsColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.iconsColor,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        iconColor: AppColors.iconsColor,
        color: AppColors.white,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.white;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.white),
        side: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgColor,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(size: 22.r, color: AppColors.primary);
          }
          return IconThemeData(size: 22.r, color: AppColors.iconsBlackColor);
        }),
      ),
      // Responsive Typography System
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textBlack,
        ),
        bodyLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.secondaryTColor,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.secondaryTColor,
        ),
      ),
      cardTheme: CardThemeData(
        surfaceTintColor: AppColors.primaryDark,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.iconsColor,
        color: AppColors.bgColor,
      ),

      // Component Themes with Responsive Spacing
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.secondaryTColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.secondaryTColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.redColor, width: 2),
        ),
      ),
    );
  }
}
