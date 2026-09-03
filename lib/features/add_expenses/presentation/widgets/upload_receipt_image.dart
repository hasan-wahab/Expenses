import 'dart:io';

import 'package:expense_app/features/widgets/app_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/const_text/add_expese_text.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/secondery_text.dart';
import '../../../widgets/small_text.dart';

class UploadReceiptImage extends StatelessWidget {
  final VoidCallback onTap;
  final XFile? imagePath;
  final bool isLoading;

  const UploadReceiptImage({
    super.key,
    required this.onTap,
    this.imagePath,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallText(text: AddExpenseText.uploadReceipt),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              height: 167.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.primary),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            File(imagePath!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return _placeholder();
                            },
                          ),
                        )
                      : _placeholder(),
                  AppSpinner.overlay(show: isLoading),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.image),
        SecondaryText(text: AddExpenseText.choseImage),
      ],
    );
  }
}
