import 'package:expense_app/core/constant/const_text/personal_information_text.dart';
import 'package:expense_app/features/personal_info/presentation/bloc/personal_info_bloc.dart';
import 'package:expense_app/features/personal_info/presentation/bloc/personal_info_events.dart';
import 'package:expense_app/features/personal_info/presentation/bloc/personal_info_states.dart';
import 'package:expense_app/features/personal_info/presentation/widget/personal_info_form.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:expense_app/features/widgets/cusom_appbar.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/text_controller_extension.dart';
import '../widget/circle_avatar_widget.dart';

class PersonalInfoScreen extends StatefulWidget {
  SettingsEntityModel entityModel;
  PersonalInfoMode mode;
  PersonalInfoScreen({
    super.key,
    required this.entityModel,
    required this.mode,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  XFile? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.entityModel.name ?? '';
    emailController.text = widget.entityModel.email ?? '';
    phoneController.text = widget.entityModel.phone ?? '';
  }

  @override
  void dispose() {
    [nameController, emailController, phoneController].disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PersonalInfoBloc>(),
      child: BlocConsumer<PersonalInfoBloc, PersonalInfoStates>(
        listener: (context, state) {
          if (state is GetProfileImageState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              context.pop();
              image = state.imagePath;
            }
            if (state.status == Status.error) {
              context.showSnackBar(state.message!, isError: true);
            }
          }
          if (state is UpdatePersonalInfoState) {
            if (state.status == Status.loading) {
              context.showCustomLoading();
            }
            if (state.status == Status.success) {
              [nameController, emailController, phoneController].resetAll();
              image = null;
              Navigator.pop(context);
              context.showSnackBar(state.message!);
              context.pop(true);
            }
            if (state.status == Status.error) {
              context.showSnackBar(state.message!, isError: true);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: PersonalInformationText.appBarText),
            body: SafeArea(
              top: false,
              child: ListView(
                padding: .symmetric(horizontal: 20.w),
                children: [
                SizedBox(height: 24.h),

                /// Circle Avatar
                CircleAvatarWidget(
                  mode: widget.mode,
                  onTap: () async {
                    final source = await context.showImageSourcePicker();
                    if (source == null || !context.mounted) return;
                    context.read<PersonalInfoBloc>().add(
                      PickImageEvent(source: source),
                    );
                  },
                  imagePath: image?.path ?? widget.entityModel.imageUrl,
                ),
                SizedBox(height: 24.h),

                /// Personal Info From
                PersonalInfoForm(
                  mode: widget.mode,
                  controllers: [
                    nameController,
                    emailController,
                    phoneController,
                  ],
                ),
                SizedBox(height: 40.h),

                /// Save Changes Button
                widget.mode == PersonalInfoMode.update
                    ? PrimaryButton(
                        text: PersonalInformationText.save,
                        onTap: () {
                          context.read<PersonalInfoBloc>().add(
                            UpdatePersonalInfoEvent(
                              entityModel: widget.entityModel.copyWith(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                isEnableFingerPrint:
                                    widget.entityModel.isEnableFingerPrint,
                                imageUrl:
                                    image?.path ?? widget.entityModel.imageUrl,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
              ),
            ),
          );
        },
      ),
    );
  }
}
