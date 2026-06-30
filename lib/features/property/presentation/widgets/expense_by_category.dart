import 'package:expense_app/core/constant/const_text/property_screen_text.dart';
import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/extra_small_text.dart';
import 'package:expense_app/features/widgets/secondery_text.dart';
import 'package:expense_app/features/widgets/small_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseByCategoryChart extends StatelessWidget {
  const ExpenseByCategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(24.r),
      decoration: BoxDecoration(
        borderRadius: .circular(12.r),
        border: .all(color: AppColors.primary),
      ),
      child: Column(
        spacing: 16.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecondaryText(text: PropertyScreenText.expenseCate),
          Row(
            mainAxisSize: .min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: .circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                height: 180.h,
                width: 180.w,
                child: PieChart(
                  PieChartData(
                    titleSunbeamLayout: true,
                    centerSpaceRadius: 0,
                    sectionsSpace: 0,
                    sections: sections(chartSize: 180.r, chartValue: 122),
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  alignment: .end,
                  runSpacing: 12.h,
                  spacing: 12.w,
                  children: [
                    ReusableRowOfChart(),
                    ReusableRowOfChart(),
                    ReusableRowOfChart(),
                    ReusableRowOfChart(),
                    ReusableRowOfChart(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> sections({
  required double chartSize,
  required double chartValue,
}) {
  final double radius = chartSize / 2;

  return List.generate(
    (5),
    (index) => switch (index) {
      0 => PieChartSectionData(
        color: AppColors.primary,
        value: chartValue,
        radius: radius,
      ),
      1 => PieChartSectionData(
        color: AppColors.iconsBlackColor,
        value: chartValue,
        radius: radius,
      ),
      2 => PieChartSectionData(
        color: AppColors.white,
        value: chartValue,
        radius: radius,
      ),
      3 => PieChartSectionData(
        color: AppColors.primary,
        value: chartValue,
        radius: radius,
      ),
      4 => PieChartSectionData(
        color: AppColors.iconsBlackColor,
        value: chartValue,
        radius: radius,
      ),
      _ => throw UnimplementedError(),
    },
  );
}

class ReusableRowOfChart extends StatelessWidget {
  const ReusableRowOfChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        Container(
          height: 12.h,
          width: 12.w,
          decoration: BoxDecoration(color: AppColors.primary, shape: .circle),
        ),
        ExtraSmallText(text: 'Petrol (30%)'),
      ],
    );
  }
}
