import 'package:expense_app/core/constant/const_text/dashboard_text.dart';
import 'package:expense_app/core/constant/const_text/monthly_summary_text.dart';
import 'package:expense_app/core/constant/const_text/property_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_property/presentation/bloc/add_property_bloc.dart';
import 'package:expense_app/features/add_property/presentation/widgets/category_droupdown.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/dashboard/presentation/bloc/dashboard_events.dart';
import 'package:expense_app/features/widgets/app_t_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/extensions/text_controller_extension.dart';
import '../../../widgets/cusom_appbar.dart';
import '../../../widgets/priamary_butn.dart';
import '../bloc/add_property_event.dart';
import '../bloc/add_property_states.dart';
import '../widgets/card_pick_image.dart';

class AddPropertyScreen extends StatefulWidget {
  final DashboardCardEntity? cardEntity;
  final AddPropertyMode? mode;

  const AddPropertyScreen({
    super.key,
    required this.cardEntity,
    this.mode = AddPropertyMode.add,
  });

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController propertyLocationController =
      TextEditingController();
  final TextEditingController targetBudgetController = TextEditingController();

  String propertyType = '';
  XFile? image;

  @override
  void initState() {
    super.initState();
    final property = widget.cardEntity;
    propertyNameController.text = property?.propertyName ?? '';
    propertyLocationController.text = property?.propertyLocation ?? '';
    targetBudgetController.text = property?.monthlyBudget.toString() ?? '';
    propertyType = property?.categoryType ?? '';
    image = property != null && property.imageUrl.isNotEmpty
        ? XFile(property.imageUrl)
        : null;
  }

  void _resetForm() {
    [
      propertyNameController,
      propertyLocationController,
      targetBudgetController,
    ].resetAll();
    propertyType = '';
    image = null;
  }

  @override
  void dispose() {
    [
      propertyNameController,
      propertyLocationController,
      targetBudgetController,
    ].disposeAll();
    super.dispose();
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
            if (state.status == Status.success) {
              _resetForm();
              context.pop(true);
            }
            if (state.status == Status.error) {
              context.showSnackBar(state.message.toString(), isError: true);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: CustomAppBar(title: 'Add Property Card'),
            body: SafeArea(
              top: false,
              child: ListView(
                padding: .symmetric(horizontal: 20.w),
                children: [
                SizedBox(height: 24.h),

                /// Pick Image Container of the Property
                CardPickImage(
                  imagePath: image,
                  onTap: () async {
                    final source = await context.showImageSourcePicker();
                    if (source == null || !context.mounted) return;
                    context.read<AddPropertyBloc>().add(
                      OnPickImageEvent(imageSource: source),
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
                  text: widget.mode == AddPropertyMode.update
                      ? 'Update Property'
                      : 'Save Property',
                  onTap: () {
                    final model = DashboardCardEntity(
                      cardId: DateTime.now().microsecondsSinceEpoch,
                      propertyName: propertyNameController.text,
                      monthlyBudget: double.parse(targetBudgetController.text),
                      propertyLocation: propertyLocationController.text,
                      imageUrl: image?.path != null ? image!.path : '',
                      syncStatus: SyncStatus.pending,
                      createAt: DateTime.now().toString(),
                      categoryType: propertyType,
                    );
                    if (widget.mode == AddPropertyMode.add) {
                      context.read<AddPropertyBloc>().add(
                        OnAddPropertyCardEvent(model: model),
                      );
                    } else {
                      final targetBudget = double.parse(
                        targetBudgetController.text,
                      );
                      final percent =
                          (widget.cardEntity!.monthlyExpenses! / targetBudget) *
                          100;

                      context.read<AddPropertyBloc>().add(
                        OnUpdatePropertyCardEvent(
                          model: model.copyWith(
                            cardId: widget.cardEntity!.cardId,
                            updateAt: DateTime.now().toString(),
                            createAt: widget.cardEntity!.createAt,
                            monthlyExpenses: widget.cardEntity!.monthlyExpenses,
                            monthlyBudget: targetBudget,
                            progress: percent,
                            isDeleted: widget.cardEntity!.isDeleted,
                            syncStatus: SyncStatus.pending,
                            imageUrl: widget.cardEntity!.imageUrl,
                            categoryType: propertyType,
                            propertyName: propertyNameController.text,
                            propertyLocation: propertyLocationController.text,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
              ),
            ),
          );
        },
      ),
    );
  }
}
