import 'package:expense_app/core/constant/const_text/settings_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/get_it.dart';
import '../bloc/settings_states.dart';

class MinProfileInfoCard extends StatelessWidget {
  SettingsEntityModel entityModel = SettingsEntityModel();

   MinProfileInfoCard({super.key,required this.entityModel});


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: .all(16.r),
        decoration: BoxDecoration(
          borderRadius: .circular(12.r),
          // border: .all(color: AppColors.primary),
        ),
        child: Row(
          spacing: 24.w,
          children: [
            /// Profile Image
            Stack(
              alignment: .bottomEnd,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    border: .all(color: AppColors.primary, width: 2),
                    shape: .circle,
                  ),
                  child: Icon(Icons.person),
                ),
                Container(
                  height: 25.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppColors.white,
                    size: 15.r,
                  ),
                ),
              ],
            ),

            /// Info Column
            Column(
              crossAxisAlignment: .start,
              children: [
                SecondaryText(text: entityModel.email.toString()),
                SmallText(text: entityModel.name.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
