import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/profile_avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/enums.dart';

class CircleAvatarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;
  final String? name;
  final PersonalInfoMode mode;
  const CircleAvatarWidget({
    super.key,
    required this.onTap,
    this.imagePath,
    this.name,
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
                  alignment: Alignment.bottomRight,
                  children: [
                    Card(
                      child: Container(
                        height: 128.h,
                        width: 128.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: ProfileAvatarImage(
                            imageUrl: imagePath,
                            name: name,
                            fontSize: 48.sp,
                          ),
                        ),
                      ),
                    ),
                    mode == PersonalInfoMode.add
                        ? Container()
                        : Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              border: Border.all(color: AppColors.white),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: context.iconOnPrimary,
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
