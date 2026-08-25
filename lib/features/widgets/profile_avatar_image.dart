import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows network / local profile image, or username initial when missing.
class ProfileAvatarImage extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? email;
  final double? fontSize;

  const ProfileAvatarImage({
    super.key,
    this.imageUrl,
    this.name,
    this.email,
    this.fontSize,
  });

  Widget _buildInitial() {
    final letter = name.hasValue ? name.initialLetter : email.initialLetter;
    return Center(
      child: Text(
        letter,
        style: TextStyle(
          fontSize: fontSize ?? 28.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = imageUrl.orEmpty;
    if (path.isEmpty) return _buildInitial();

    if (path.isNetworkUrl) {
      return Image.network(
        path,
        key: ValueKey(path),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return AppShimmer(
            child: AppShimmer.circle(size: 40),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildInitial(),
      );
    }

    return Image.file(
      File(path),
      key: ValueKey(path),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildInitial(),
    );
  }
}
