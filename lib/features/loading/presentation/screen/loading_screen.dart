import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/features/widgets/app_spinner.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(child: AppSpinner()),
    );
  }
}
