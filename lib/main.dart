import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/constant/themes/themes/themes.dart';
import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/core/get_it.dart';
import 'package:expense_app/core/router/route_generator.dart';
import 'package:expense_app/features/auth/presentation/screen/auth_screen.dart';
import 'package:expense_app/features/auth/presentation/screen/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDyzrzayRJDSr1rgMcg3DJWaqdw7T0iKX8',
      appId: '1:301740951111:android:ff6f52a6dcf72d2e20d362',
      messagingSenderId: '301740951111',
      projectId: 'learningapp-4c35b',
    ),
  );
  getITSetup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.system,
          routerConfig: RouteGenerator.route,
        );
      },
    );
  }
}
