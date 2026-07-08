import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardPickImage extends StatelessWidget {
  final VoidCallback onTap;
  final File? imageFile;
  const CardPickImage({super.key, required this.onTap, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 160.h,
          width: .infinity,
          decoration: BoxDecoration(borderRadius: .circular(12.r)),
          child: imageFile != null
              ? ClipRRect(
                  borderRadius: .circular(12.r),
                  child: Image.file(imageFile!, fit: .fill),
                )
              : Column(
                  mainAxisSize: .min,
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.image),
                    SmallText(text: 'Tap here to pick image'),
                  ],
                ),
        ),
      ),
    );
  }
}
