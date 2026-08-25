import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:expense_app/features/widgets/profile_avatar_image.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/constant/wrapers.dart';
import '../../../../core/router/routes_name.dart';
import '../bloc/settings_events.dart';

class MinProfileInfoCard extends StatelessWidget {
  SettingsEntityModel entityModel = SettingsEntityModel();

  MinProfileInfoCard({super.key, required this.entityModel});

  @override
  Widget build(BuildContext context) {
    final name = entityModel.name.orEmpty;
    final email = entityModel.email.orEmpty;

    return Card(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          spacing: 24.w,
          children: [
            /// Profile Image
            InkWell(
              onTap: () async {
                final result = await context.push(
                  RoutesName.personalInfoScreen,
                  extra: PersonalInfoArgs(
                    entity: entityModel,
                    mode: PersonalInfoMode.update,
                  ),
                );
                if (result == true) {
                  if (!context.mounted) return;
                  context.read<SettingsBloc>().add(OnSettingsEvent());
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: Container(
                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: ProfileAvatarImage(
                        imageUrl: entityModel.imageUrl,
                        name: name,
                        email: email,
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                  Container(
                    height: 25.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(Icons.edit, color: context.iconOnPrimary, size: 15.r),
                  ),
                ],
              ),
            ),

            /// Info Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecondaryText(text: name.isNotEmpty ? name : email),
                if (name.isNotEmpty && email.isNotEmpty) SmallText(text: email),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
