import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_bloc.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/get_it.dart';
import '../../../../core/utils/image_picker.dart';
import '../../../widgets/cusom_appbar.dart';
import '../../../widgets/priamary_butn.dart';
import '../bloc/add_property_event.dart';
import '../bloc/add_property_states.dart';
import '../widgets/card_pick_image.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  File? pickImage;
  TextEditingController propertyName = TextEditingController();
  TextEditingController propertyType = TextEditingController();
  TextEditingController propertyLocation = TextEditingController();
  TextEditingController targetBudget = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: 'Add Property Card'),
      body: BlocProvider(
        create: (context) => sl<AddPropertyBloc>(),
        child: BlocConsumer<AddPropertyBloc, AddPropertyStates>(
          listener: (context, state) {
            if (state is PickImageState) {
              if (state.status == Status.success) {
                if (context.canPop()) {
                  context.pop();
                  pickImage = state.image;
                }
                pickImage = state.image;
              }
              if (state.status == Status.error) {
                if (context.canPop()) {
                  context.pop();
                }
                print(state.message);
              }
              if (state.status == Status.loading) {
                if (context.canPop()) {
                  context.pop();
                  context.showCustomLoading();
                }
                context.showCustomLoading();
              }
            }
            if (state is GetPropertyCardState) {
              if (state.status == Status.success) {
                if (context.canPop()) {
                  context.pop();
                  context.showSnackBar(state.message!);
                }
                context.showSnackBar(state.message!);
                context.go(RoutesName.naveBar);
              }
              if (state.status == Status.error) {
                if (context.canPop()) {
                  context.pop();
                }
                print(state.message);
              }
              if (state.status == Status.loading) {
                if (context.canPop()) {
                  context.pop();
                  context.showCustomLoading();
                }
                context.showCustomLoading();
              }
            }
          },
          builder: (context, state) {
            return ListView(
              padding: .symmetric(horizontal: 20.w),
              children: [
                SizedBox(height: 24.h),

                /// Pick Image Container of the Property
                CardPickImage(
                  imageFile: pickImage,
                  onTap: () => context.read<AddPropertyBloc>().add(
                    OnPickImageEvent(imageSource: ImageSource.gallery),
                  ),
                ),
                SizedBox(height: 24.h),

                /// Property Name Field
                AppTField(
                  controller: propertyName,
                  startIcon: Icons.home_filled,
                  hintText: 'Property Name...',
                  labelText: 'Property Name',
                ),
                SizedBox(height: 24.h),

                /// Category Type Field
                AppTField(
                  controller: propertyType,
                  startIcon: Icons.home_filled,
                  hintText: 'Property Type...',
                  labelText: 'Property Type',
                ),
                SizedBox(height: 24.h),

                /// Property Location Field
                AppTField(
                  controller: propertyLocation,
                  startIcon: Icons.location_on,
                  hintText: 'Property Location...',
                  labelText: 'Property Location',
                ),
                SizedBox(height: 24.h),

                /// Target Budget Field
                AppTField(
                  controller: targetBudget,
                  startIcon: Icons.attach_money,
                  hintText: 'Target Budget...',
                  labelText: 'Target Budget',
                ),
                SizedBox(height: 24.h),

                /// Save Button
                PrimaryButton(
                  text: 'Save Property',
                  onTap: () {
                    DashboardCardEntity model = DashboardCardEntity(
                      propertyName: propertyName.text,
                      categoryType: propertyType.text,
                      propertyLocation: propertyLocation.text,
                      monthlyBudget: double.parse(targetBudget.text),
                      imageUrl: pickImage.toString(),
                      createAt: DateTime.now().toString(),
                    );
                    context.read<AddPropertyBloc>().add(
                      OnAddPropertyCardEvent(model: model),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
