import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.h,
      children: [
        AppTField(
          startIcon: Icons.person,
          hintText: PersonalInformationText.fullName,
          labelText: PersonalInformationText.fullName,
        ),
        AppTField(
          startIcon: Icons.email,
          hintText: PersonalInformationText.email,
          labelText: PersonalInformationText.emailAddress,
        ),
        AppTField(
          startIcon: Icons.phone,
          hintText: PersonalInformationText.phoneNumber,
          labelText: PersonalInformationText.phone,
        ),
      ],
    );
  }
}
