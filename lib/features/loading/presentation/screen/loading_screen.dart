import 'package:expense_app/features/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: AppShimmer.page()),
    );
  }
}
