import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/presentation/screen/add_expenses_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/login_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:expense_app/features/budget_alerts/presentation/screen/budgets_alerts_screen.dart';
import 'package:expense_app/features/comparison/presentation/screen/comparison_screen.dart';
import 'package:expense_app/features/currency/presentation/screen/currency_screen.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/export_to_pdf_screen.dart';
import 'package:expense_app/features/loading/presentation/screen/loading_screen.dart';
import 'package:expense_app/features/message/presentation/screen/message_screen.dart';
import 'package:expense_app/features/monthly_summary/presentation/screen/monthly_summary_screen.dart';
import 'package:expense_app/features/nave_bar/presentation/screen/nave_bar.dart';
import 'package:expense_app/features/no_internet/presentation/screen/internet_status_screen.dart';
import 'package:expense_app/features/notification/presentation/screen/notification_screen.dart';
import 'package:expense_app/features/personal_info/presentation/screen/personal_info_screen.dart';
import 'package:expense_app/features/property/presentation/screen/property_screen.dart';
import 'package:expense_app/features/property/presentation/widgets/expense_by_category.dart';
import 'package:expense_app/features/settings/presentation/screen/settings_screen.dart';
import 'package:expense_app/features/test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/screen/dashboard_screen.dart';

class RouteGenerator {
  static GoRoute _goRoute({
    required String routeName,
    required Widget Function(BuildContext context, GoRouterState state) screen,
  }) => GoRoute(
    path: routeName,
    builder: (context, state) {
      return screen(context, state);
    },
  );

  static GoRouter get route => GoRouter(
    initialLocation: RoutesName.naveBar,
    routes: [
      _goRoute(
        routeName: RoutesName.login,
        screen: (context, state) => LoginScreen(),
      ),
      _goRoute(
        routeName: RoutesName.singUp,
        screen: (context, state) => SignUpScreen(),
      ),
      _goRoute(
        routeName: RoutesName.dashboard,
        screen: (context, state) => DashboardScreen(),
      ),
      _goRoute(
        routeName: RoutesName.messageScreen,
        screen: (context, state) =>
            MessageScreen(message: state.extra as String),
      ),
      _goRoute(
        routeName: RoutesName.loadingScreen,
        screen: (context, state) => LoadingScreen(),
      ),
      _goRoute(
        routeName: RoutesName.propertyScreen,
        screen: (context, state) => PropertyScreen(),
      ),
      _goRoute(routeName: RoutesName.test, screen: (context, state) => Test()),
      _goRoute(
        routeName: RoutesName.notificationScreen,
        screen: (context, state) => NotificationScreen(),
      ),
      _goRoute(
        routeName: RoutesName.currencyScreen,
        screen: (context, state) => CurrencyScreen(),
      ),
      _goRoute(
        routeName: RoutesName.naveBar,
        screen: (context, state) => NaveBar(),
      ),
      _goRoute(
        routeName: RoutesName.budgetsAlertsScreen,
        screen: (context, state) => BudgetsAlertsScreen(),
      ),
      _goRoute(
        routeName: RoutesName.settingsScreen,
        screen: (context, state) => SettingsScreen(),
      ),
      _goRoute(
        routeName: RoutesName.personalInfoScreen,
        screen: (context, state) => PersonalInfoScreen(),
      ),
      _goRoute(
        routeName: RoutesName.exportToPdfScreen,
        screen: (context, state) => ExportToPdfScreen(),
      ),
      _goRoute(
        routeName: RoutesName.comparisonScreen,
        screen: (context, state) => ComparisonScreen(),
      ),
      _goRoute(
        routeName: RoutesName.addExpenseScreen,
        screen: (context, state) => AddExpensesScreen(),
      ),
      _goRoute(
        routeName: RoutesName.internetStatusScreen,
        screen: (context, state) => InternetStatusScreen(),
      ),
      _goRoute(
        routeName: RoutesName.monthlySummary,
        screen: (context, state) => MonthlySummaryScreen(),
      ),
    ],
  );
}
