import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/small_text.dart';

class DeviderRow extends StatelessWidget {
  const DeviderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        SizedBox(
          width: 133.9.w,
          child: Divider(
            thickness: 1,
            color: AppColors.secondaryTColor,
          ),
        ),
        SmallText(text: 'Or'),
        SizedBox(
          width: 133.9.w,
          child: Divider(
            thickness: 1,
            color: AppColors.secondaryTColor,
          ),
        ),
      ],
    );
  }
}
