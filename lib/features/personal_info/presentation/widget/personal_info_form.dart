import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../settings/domain/entitity/settings_entity.dart';

class PersonalInfoForm extends StatelessWidget {
  List<TextEditingController> controllers = [];
  PersonalInfoMode mode;

  PersonalInfoForm({super.key, required this.controllers, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.h,
      children: [
        AppTField(
          enabled: mode == PersonalInfoMode.update ? true : false,
          controller: controllers[0],
          startIcon: Icons.person,
          hintText: PersonalInformationText.fullName,
          labelText: PersonalInformationText.fullName,
        ),
        InkWell(
          onTap: () {
            context.showSnackBar('Email is not editable', isError: true);
          },
          child: AppTField(
            enabled: false,
            controller: controllers[1],
            startIcon: Icons.email,
            hintText: PersonalInformationText.email,
            labelText: PersonalInformationText.emailAddress,
          ),
        ),
        AppTField(
          enabled: mode == PersonalInfoMode.update ? true : false,
          keyboardType: .phone,
          controller: controllers[2],
          startIcon: Icons.phone,
          hintText: PersonalInformationText.phoneNumber,
          labelText: PersonalInformationText.phone,
        ),
      ],
    );
  }
}
