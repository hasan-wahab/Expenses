import 'dart:async';
import 'dart:typed_data';

import 'package:expense_app/core/router/routes_name.dart';
import 'package:expense_app/features/add_expenses/presentation/screen/add_expenses_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/login_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/sign_up_screen.dart';

import 'package:expense_app/features/add_property/presentation/screen/add_property_screen.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/export_to_pdf_screen.dart';
import 'package:expense_app/features/export_pdf/presentation/screen/pdf_preview_screen.dart';
import 'package:expense_app/features/loading/presentation/screen/loading_screen.dart';
import 'package:expense_app/features/nave_bar/presentation/screen/nave_bar.dart';
import 'package:expense_app/features/notification/presentation/screen/notification_screen.dart';
import 'package:expense_app/features/personal_info/presentation/screen/personal_info_screen.dart';

import 'package:expense_app/features/settings/presentation/screen/settings_screen.dart';
import 'package:expense_app/features/splash/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';

import '../../features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../features/category_detail/presentation/screen/category_detail_screen.dart';
import '../../features/category_detail/presentation/screen/expense_detail_screen.dart';
import '../../features/category_detail/presentation/screen/receipt_full_screen.dart';
import '../../features/dashboard/presentation/screen/dashboard_screen.dart';
import '../../features/summary/presentation/screen/summary_screen.dart';
import '../../features/sync_data/presentation/screen/sync_data_screen.dart';
import '../constant/enums.dart';
import '../constant/wrapers.dart';

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
    initialLocation: RoutesName.splash,
    routes: [
      _goRoute(
        routeName: RoutesName.splash,
        screen: (context, state) => const SplashScreen(),
      ),
      _goRoute(
        routeName: RoutesName.login,
        screen: (context, state) => LoginScreen(),
      ),
      _goRoute(
        routeName: RoutesName.addPropertyScreen,
        screen: (context, state) {
          final args = state.extra as AppPropertyArgs;
          return AddPropertyScreen(
            cardEntity: args.cardEntity,
            mode: args.mode,
          );
        },
      ),
      _goRoute(
        routeName: RoutesName.syncDataScreen,
        screen: (context, state) {
          final args = state.extra as bool? ?? false;
          return SyncDataScreen(isFingerPrint: args);
        },
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
        routeName: RoutesName.loadingScreen,
        screen: (context, state) => LoadingScreen(),
      ),

      _goRoute(
        routeName: RoutesName.naveBar,
        screen: (context, state) => NaveBar(),
      ),

      _goRoute(
        routeName: RoutesName.settingsScreen,
        screen: (context, state) => SettingsScreen(),
      ),
      _goRoute(
        routeName: RoutesName.personalInfoScreen,
        screen: (context, state) {
          final args = state.extra as PersonalInfoArgs;
          return PersonalInfoScreen(entityModel: args.entity!, mode: args.mode);
        },
      ),
      _goRoute(
        routeName: RoutesName.exportToPdfScreen,
        screen: (context, state) => ExportToPdfScreen(),
      ),
      _goRoute(
        routeName: RoutesName.pdfPreviewScreen,
        screen: (context, state) {
          final ags = state.extra as PdfPreviewArgs;
          return PdfPreviewScreen(
            propertyName: ags.propertyName,
            build: ags.build,
          );
        },
      ),

      _goRoute(
        routeName: RoutesName.addExpenseScreen,
        screen: (context, state) =>
            AddExpensesScreen(propertyCardId: state.extra as String),
      ),

      _goRoute(
        routeName: RoutesName.monthlySummary,
        screen: (context, state) {
          return SummaryScreen(propertyCardId: state.extra as int);
        },
      ),
      _goRoute(
        routeName: RoutesName.categoryDetailScreen,
        screen: (context, state) {
          return CategoryDetailScreen(
            expenses: state.extra as List<ExpenseEntity>,
          );
        },
      ),
      _goRoute(
        routeName: RoutesName.expenseDetailScreen,
        screen: (context, state) {
          return ExpenseDetailScreen(
            expense: state.extra as ExpenseEntity,
          );
        },
      ),
      _goRoute(
        routeName: RoutesName.receiptFullScreen,
        screen: (context, state) {
          return ReceiptFullScreen(
            imagePath: state.extra as String,
          );
        },
      ),
    ],
  );
}
