import 'package:expense_app/core/constant/const_text/export_pdf_text.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/extensions/date_extension.dart';
import 'package:expense_app/features/add_expenses/presentation/widgets/date_selection.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/export_to_pdf_screen.dart';
import 'package:expense_app/features/settings/presentation/widgets/account_settings.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/enums.dart';
import '../../../../core/constant/themes/themes/colors.dart';
import '../../../widgets/priamary_butn.dart';
import '../bloc/export_to_pdf_bloc.dart';
import '../bloc/export_to_pdf_events.dart';

class SelectionPeriodCard extends StatefulWidget {
  String propertyCardId;
  SelectionPeriodCard({super.key, required this.propertyCardId});

  @override
  State<SelectionPeriodCard> createState() => _SelectionPeriodCardState();
}

class _SelectionPeriodCardState extends State<SelectionPeriodCard> {
  DateTime? startDate;
  DateTime? endDate;
  final List<bool> _isSelected = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: .start,
      children: [
        SecondaryText(text: ExportPdfText.selectPeriod),

        Card(
          child: Column(
            children: [
              ExportToPdfTiles(
                onChange: (value) {
                  if (value) {
                    setState(() {
                      _isSelected[0] = value;
                      _isSelected[1] = false;
                      _isSelected[2] = false;
                    });
                  }
                },
                isOn: _isSelected[0],
                iconSize: 18.r,
                title: ExportPdfText.thisMonth,
                leadingIcon: Icons.calendar_month,
                trailingIcon: Icons.keyboard_arrow_down_rounded,
              ),
              ExportToPdfTiles(
                onChange: (value) {
                  if (value) {
                    setState(() {
                      _isSelected[0] = false;
                      _isSelected[1] = value;
                      _isSelected[2] = false;
                    });
                  }
                },
                isOn: _isSelected[1],
                iconSize: 18.r,
                title: ExportPdfText.lastQuarter,
                leadingIcon: Icons.calendar_month,
                trailingIcon: Icons.keyboard_arrow_down_rounded,
              ),
              ExportToPdfTiles(
                onChange: (value) {
                  if (value) {
                    setState(() {
                      _isSelected[0] = false;
                      _isSelected[1] = false;
                      _isSelected[2] = value;
                    });
                  }
                },
                isOn: _isSelected[2],
                isShowLastIndexDivider: false,
                iconSize: 18.r,
                title: ExportPdfText.customRange,
                leadingIcon: Icons.calendar_month,
                trailingIcon: Icons.keyboard_arrow_down_rounded,
              ),
              _isSelected[2] == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: 16.h,
                        bottom: 16.w,
                        left: 16.w,
                        right: 16.w,
                      ),
                      child: Row(
                        spacing: 16.w,
                        children: [
                          /// Start Date
                          Expanded(
                            child: DateSelection(
                              selectedDate:
                                  startDate?.toDisplayDate() ?? 'Start Date',
                              onTap: () async {
                                startDate =
                                    (await context.showAppDatePicker()) ??
                                    DateTime.now();
                                setState(() {});
                              },
                            ),
                          ),

                          /// End Date
                          Expanded(
                            child: DateSelection(
                              selectedDate:
                                  endDate?.toDisplayDate() ?? 'End Date',
                              onTap: () async {
                                endDate =
                                    (await context.showAppDatePicker()) ??
                                    DateTime.now();
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),

        /// Export Formate
        PrimaryButton(
          text: 'Export to PDF',
          onTap: () {
            if (widget.propertyCardId == '' && widget.propertyCardId.isEmpty) {
              context.showSnackBar('Select property', isError: true);
            } else {
              if (_isSelected[0] == true) {
                context.read<ExportToPdfBloc>().add(
                  ExportToPdfEvent(
                    propertyCardId: widget.propertyCardId,
                    mode: ExportToPdfMode.thisMonth,
                  ),
                );
              } else if (_isSelected[1] == true) {
                context.read<ExportToPdfBloc>().add(
                  ExportToPdfEvent(
                    propertyCardId: widget.propertyCardId,
                    mode: ExportToPdfMode.lastQuarter,
                  ),
                );
              } else if (_isSelected[2] == true) {
                if (startDate != null && endDate != null) {
                  context.read<ExportToPdfBloc>().add(
                    ExportToPdfEvent(
                      propertyCardId: widget.propertyCardId,
                      mode: ExportToPdfMode.customRange,
                      startDate: startDate,
                      endDate: endDate,
                    ),
                  );
                } else {
                  context.showSnackBar('Select date', isError: true);
                }
              } else {
                context.showSnackBar('Select period', isError: true);
              }
            }
          },
        ),
      ],
    );
  }
}

class ExportToPdfTiles extends StatelessWidget {
  final String title;
  final double? iconSize;
  final Function(bool) onChange;
  final bool isOn;
  final IconData leadingIcon;
  final IconData trailingIcon;
  bool isShowLastIndexDivider;

  ExportToPdfTiles({
    super.key,
    required this.title,
    this.isOn = false,
    required this.leadingIcon,
    required this.trailingIcon,
    this.isShowLastIndexDivider = true,
    this.iconSize,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: .symmetric(horizontal: 16.w),
          leading: Icon(leadingIcon),
          title: SecondaryText(text: title),
          trailing: Checkbox(
            value: isOn,
            onChanged: (value) => onChange(value!),
          ),
        ),
        isShowLastIndexDivider
            ? Divider(
                color: AppColors.primary.withOpacity(0.2),
                thickness: 1.h,
                height: 1.h,
              )
            : Container(),
      ],
    );
  }
}
