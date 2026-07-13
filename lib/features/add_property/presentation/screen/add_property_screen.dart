import 'dart:io';

import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/const_text/property_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_bloc.dart';
import 'package:expense_app/features/add_property/presentation/widgets/category_droupdown.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/utils/image_picker.dart';
import '../../../widgets/cusom_appbar.dart';
import '../../../widgets/priamary_butn.dart';
import '../bloc/add_property_event.dart';
import '../bloc/add_property_states.dart';
import '../widgets/card_pick_image.dart';

class AddPropertyScreen extends StatefulWidget {
  final DashboardCardEntity? dashboardCardEntity;

  const AddPropertyScreen({super.key, required this.dashboardCardEntity});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  TextEditingController propertyNameController = TextEditingController();
  TextEditingController propertyLocationController = TextEditingController();
  TextEditingController targetBudgetController = TextEditingController();

  String propertyType = '';
  XFile? image;

  @override
  void initState() {
    propertyNameController = TextEditingController(
      text: widget.dashboardCardEntity?.propertyName,
    );
    propertyLocationController = TextEditingController(
      text: widget.dashboardCardEntity?.propertyLocation,
    );
    targetBudgetController = TextEditingController(
      text: widget.dashboardCardEntity?.monthlyBudget.toString(),
    );
    propertyType = widget.dashboardCardEntity?.categoryType ?? '';
    image = widget.dashboardCardEntity != null
        ? XFile(widget.dashboardCardEntity!.imageUrl)
        : image;
    print(propertyType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddPropertyBloc>(),
      child: BlocConsumer<AddPropertyBloc, AddPropertyStates>(
        listener: (context, state) {
          if (state is PickImageState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              context.pop();
              image = state.imagePath;
            }
            if (state.status == Status.error) {
              print(state.message);
            }
          }
          if (state is GetAddedPropertyCardState) {
            print(state.status);
            if (state.status == Status.success) {
              context.pop(true);
            }
            if (state.status == Status.error) {
              context.showSnackBar(state.message.toString());
              print(state.message);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: CustomAppBar(title: 'Add Property Card'),
            body: ListView(
              padding: .symmetric(horizontal: 20.w),
              children: [
                SizedBox(height: 24.h),

                /// Pick Image Container of the Property
                CardPickImage(
                  imagePath: image,
                  onTap: () {
                    context.read<AddPropertyBloc>().add(
                      OnPickImageEvent(imageSource: ImageSource.gallery),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                /// Property Name Field
                AppTField(
                  controller: propertyNameController,
                  startIcon: Icons.home_filled,
                  hintText: 'Property Name...',
                  labelText: 'Property Name',
                ),
                SizedBox(height: 24.h),

                /// Category Type Field
                CategoryDropdown(
                  initialValue: propertyType,
                  selectedItem: ValueNotifier(propertyType),
                  onChange: (value) {
                    propertyType = value;
                    print(propertyType);
                  },
                ),
                SizedBox(height: 24.h),

                /// Property Location Field
                AppTField(
                  controller: propertyLocationController,
                  startIcon: Icons.location_on,
                  hintText: 'Property Location...',
                  labelText: 'Property Location',
                ),
                SizedBox(height: 24.h),

                /// Target Budget Field
                AppTField(
                  controller: targetBudgetController,
                  keyboardType: .number,
                  startIcon: Icons.attach_money,
                  hintText: 'Target Budget...',
                  labelText: 'Target Budget',
                ),
                SizedBox(height: 24.h),

                /// Save Button
                PrimaryButton(
                  text: 'Save Property',
                  onTap: () {
                    context.read<AddPropertyBloc>().add(
                      OnAddPropertyCardEvent(
                        model: DashboardCardEntity(
                          syncStatus: SyncStatus.pending,
                          propertyName: propertyNameController.text,
                          monthlyBudget: double.parse(
                            targetBudgetController.text,
                          ),
                          cardId: DateTime.now().microsecondsSinceEpoch,
                          createAt: DateTime.now().toString(),
                          propertyLocation: propertyLocationController.text,
                          categoryType: propertyType,
                          imageUrl: image?.path != null ? image!.path : '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
