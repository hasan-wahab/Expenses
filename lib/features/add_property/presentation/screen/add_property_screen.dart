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
  final int cardId;
  const AddPropertyScreen({super.key, required this.cardId});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  XFile? pickImage;
  TextEditingController propertyName = TextEditingController();
  String propertyType = '';
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
              switch (state.status) {
                case Status.initial:
                  // TODO: Handle this case.
                  throw UnimplementedError();
                case Status.loading:

                  /// Show Loading
                  context.showCustomLoading();
                case Status.success:

                  /// Hide Loading
                  if (context.canPop()) {
                    context.pop();

                    /// Assign Image Path to variable to show in UI
                    pickImage = state.imagePath;
                  }
                  break;
                case Status.error:

                  /// Hide Loading
                  if (context.canPop()) {
                    context.pop();

                    /// Show Error Message
                    context.showSnackBar(state.message!);
                  }
                  break;
                case Status.message:
                  // TODO: Handle this case.
                  throw UnimplementedError();
              }
            }
            if (state is GetAddedPropertyCardState) {
              switch (state.status) {
                case Status.initial:
                  // TODO: Handle this case.
                  throw UnimplementedError();
                case Status.loading:

                  /// Show Loading
                  context.showCustomLoading();
                case Status.success:

                  /// Hide Loading
                  if (context.canPop()) {
                    context.pop();

                    /// Show Success Message
                    context.showSnackBar(state.message!);

                    /// Navigate to Dashboard Screen and pass true to value for refresh property list
                    context.pop(true);
                  }
                  break;
                case Status.error:

                  /// Hide Loading
                  if (context.canPop()) {
                    context.pop();

                    /// Show Error Message
                    context.showSnackBar(state.message!);
                  }
                  break;
                case Status.message:
                  // TODO: Handle this case.
                  throw UnimplementedError();
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
                  imagePath: pickImage,
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
                CategoryDropdown(
                  selectedItem: ValueNotifier(propertyType),
                  onChange: (value) {
                    propertyType = value;
                  },
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
                  keyboardType: .number,
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
                    context.read<AddPropertyBloc>().add(
                      OnAddPropertyCardEvent(
                        cardId: widget.cardId,
                        propertyName: propertyName.text,
                        categoryType: propertyType,
                        propertyLocation: propertyLocation.text,
                        monthlyBudget: double.parse(
                          targetBudget.text.isEmpty ? '0' : targetBudget.text,
                        ),
                        imageUrl: pickImage?.path != null
                            ? pickImage!.path
                            : '',
                        createAt: DateTime.now().toString(),
                      ),
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
