import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/auth/presentation/screen/auth_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:expense_app/features/loading/presentation/screen/loading_screen.dart';
import 'package:expense_app/features/message/presentation/screen/message_screen.dart';
import 'package:expense_app/features/monthly_summary/presentation/screen/monthly_summary_screen.dart';
import 'package:expense_app/features/no_internet/presentation/screen/internet_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/screen/dashboard_screen.dart';

class RouteGenerator {
  static GoRoute _goRoute({
    required String routeName,
    required Widget screen,
  }) => GoRoute(
    path: routeName,
    builder: (context, state) {
      return screen;
    },
  );

  static GoRouter get route => GoRouter(
    initialLocation: RoutesName.loadingScreen,
    routes: [
      _goRoute(routeName: RoutesName.login, screen: LoginScreen()),
      _goRoute(routeName: RoutesName.singUp, screen: SignUpScreen()),
      _goRoute(routeName: RoutesName.dashboard, screen: DashboardScreen()),
      _goRoute(routeName: RoutesName.messageScreen, screen: MessageScreen()),
      _goRoute(routeName: RoutesName.loadingScreen, screen: LoadingScreen()),
      _goRoute(
        routeName: RoutesName.internetStatusScreen,
        screen: InternetStatusScreen(),
      ),
      _goRoute(
        routeName: RoutesName.monthlySummary,
        screen: MonthlySummaryScreen(),
      ),
    ],
  );
}
