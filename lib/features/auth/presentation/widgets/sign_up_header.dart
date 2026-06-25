import 'package:expense_app/core/constant/const_text/auth_text.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/widgets/large_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108.h,
      width: 350.w,
      child: Column(
        children: [
          LargeText(text: AuthText.joinText),
          SmallText(text: AuthText.joinSmallText.toSentenceCase()),
        ],
      ),
    );
  }
}
