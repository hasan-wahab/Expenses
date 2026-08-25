import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/themes/themes/colors.dart';
import '../../../dashboard/domain/entitity/dashboard_card_entity.dart';
import '../../../widgets/small_text.dart';

class PropertyCardDropdown extends StatelessWidget {
  final String? propertyCardId;
  final List<DashboardCardEntity> dashboardCardList;
  final Function(String?)? onSelected;

  const PropertyCardDropdown({
    super.key,
    this.propertyCardId,
    required this.onSelected,
    required this.dashboardCardList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      crossAxisAlignment: .start,
      children: [
        SmallText(text: 'Select Property'),
        DropdownButton2(
          underline: SizedBox(),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              border: .all(color: AppColors.primary),
              boxShadow: [BoxShadow(color: AppColors.bgColor)],
              borderRadius: .circular(12.r),
            ),
          ),
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              borderRadius: .circular(12.r),
              color: AppColors.bgColor,
              border: .all(color: AppColors.primary),
            ),
          ),
          isExpanded: true,
          hint: Text('Select Property'),
          valueListenable: ValueNotifier(propertyCardId),
          items: dashboardCardList
              .map(
                (e) => DropdownItem(
                  value: e.listKey,
                  child: SmallText(
                    text: e.isSharedWithMe
                        ? '${e.propertyName} (Shared)'
                        : e.propertyName,
                  ),
                ),
              )
              .toList(),
          onChanged: onSelected,
        ),
      ],
    );
  }
}
