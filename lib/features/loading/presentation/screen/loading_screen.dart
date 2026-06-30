import 'package:expense_app/features/widgets/extra_large_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/small_text.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: .all(24.r),
          child: SizedBox(
            height: .infinity,
            width: .infinity,
            child: Column(
              spacing: 20.h,
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              children: [
                ExtraLargeText(text: '90%'),
                LinearProgressIndicator(),
                SmallText(
                  align: .center,
                  text: "Fetching your property data...",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
