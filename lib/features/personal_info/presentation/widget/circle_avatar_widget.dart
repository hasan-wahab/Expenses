import 'dart:io';

import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/enums.dart';

class CircleAvatarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;
  final PersonalInfoMode mode;
  const CircleAvatarWidget({
    super.key,
    required this.onTap,
    this.imagePath,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      children: [
        SizedBox(
          height: 128.h,
          width: 128.w,
          child: Column(
            children: [
              InkWell(
                onTap: mode == PersonalInfoMode.add ? () {} : onTap,
                child: Stack(
                  alignment: .bottomEnd,
                  children: [
                    Card(
                      child: Container(
                        height: 128.h,
                        width: 128.w,
                        decoration: BoxDecoration(
                          borderRadius: .circular(12.r),
                          border: .all(color: AppColors.primary, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: .circular(12.r),
                          child: imagePath != ''
                              ? Image.file(
                                  File(imagePath!),
                                  fit: .cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image);
                                  },
                                )
                              : Icon(Icons.image),
                        ),
                      ),
                    ),
                    mode == PersonalInfoMode.add
                        ? Container()
                        : Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              shape: .circle,
                              color: AppColors.primary,
                              border: .all(color: AppColors.white),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        mode == PersonalInfoMode.add
            ? Container()
            : ExtraSmallText(text: PersonalInformationText.changeAvatar),
      ],
    );
  }
}
