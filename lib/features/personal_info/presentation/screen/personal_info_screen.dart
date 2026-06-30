import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/features/personal_info/presentation/widget/personal_info_form.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/circle_avatar_widget.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: PersonalInformationText.appBarText),
      body: ListView(
        padding: .symmetric(horizontal: 20.w),
        children: [
          SizedBox(height: 24.h),

          /// Circle Avatar
          CircleAvatarWidget(),
          SizedBox(height: 24.h),

          /// Personal Info From
          PersonalInfoForm(),
          SizedBox(height: 40.h),

          /// Save Changes Button
          PrimaryButton(text: PersonalInformationText.save, onTap: () {}),
        ],
      ),
    );
  }
}
