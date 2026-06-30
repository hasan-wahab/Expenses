import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/presentation/screen/add_expenses_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/auth_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:expense_app/features/budget_alerts/presentation/screen/budgets_alerts_screen.dart';
import 'package:expense_app/features/comparison/presentation/screen/comparison_screen.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/export_to_pdf_screen.dart';
import 'package:expense_app/features/loading/presentation/screen/loading_screen.dart';
import 'package:expense_app/features/message/presentation/screen/message_screen.dart';
import 'package:expense_app/features/monthly_summary/presentation/screen/monthly_summary_screen.dart';
import 'package:expense_app/features/no_internet/presentation/screen/internet_status_screen.dart';
import 'package:expense_app/features/personal_info/presentation/screen/personal_info_screen.dart';
import 'package:expense_app/features/property/presentation/screen/property_screen.dart';
import 'package:expense_app/features/property/presentation/widgets/expense_by_category.dart';
import 'package:expense_app/features/settings/presentation/screen/settings_screen.dart';
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
    initialLocation: RoutesName.login,
    routes: [
      _goRoute(routeName: RoutesName.login, screen: LoginScreen()),
      _goRoute(routeName: RoutesName.singUp, screen: SignUpScreen()),
      _goRoute(routeName: RoutesName.dashboard, screen: DashboardScreen()),
      _goRoute(routeName: RoutesName.messageScreen, screen: MessageScreen()),
      _goRoute(routeName: RoutesName.loadingScreen, screen: LoadingScreen()),
      _goRoute(routeName: RoutesName.propertyScreen, screen: PropertyScreen()),
      _goRoute(
        routeName: RoutesName.budgetsAlertsScreen,
        screen: BudgetsAlertsScreen(),
      ),
      _goRoute(routeName: RoutesName.settingsScreen, screen: SettingsScreen()),
      _goRoute(
        routeName: RoutesName.personalInfoScreen,
        screen: PersonalInfoScreen(),
      ),
      _goRoute(
        routeName: RoutesName.exportToPdfScreen,
        screen: ExportToPdfScreen(),
      ),
      _goRoute(
        routeName: RoutesName.comparisonScreen,
        screen: ComparisonScreen(),
      ),
      _goRoute(
        routeName: RoutesName.addExpenseScreen,
        screen: AddExpensesScreen(),
      ),
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
