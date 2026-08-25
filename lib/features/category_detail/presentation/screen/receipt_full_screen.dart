import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiptFullScreen extends StatelessWidget {
  final String imagePath;

  const ReceiptFullScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: 'Receipt', isLeading: true),
      body: SafeArea(
        top: false,
        child: Center(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      color: context.iconOnPrimary,
                      size: 48.r,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Unable to load receipt',
                      style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
