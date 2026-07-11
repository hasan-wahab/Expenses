import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CardPickImage extends StatelessWidget {
  final VoidCallback onTap;
  final XFile? imagePath;
  const CardPickImage({super.key, required this.onTap, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          height: 160.h,
          width: .infinity,
          decoration: BoxDecoration(borderRadius: .circular(12.r)),
          child: imagePath != null
              ? ClipRRect(
                  borderRadius: .circular(12.r),
                  child: Image.file(File(imagePath!.path), fit: .fill),
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
