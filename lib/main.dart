import 'dart:io';

import 'package:expense_app/core/constant/themes/themes/colors.dart';
import 'package:expense_app/core/constant/themes/themes/themes.dart';
import 'package:expense_app/core/di/get_it.dart';
import 'package:expense_app/core/router/route_generator.dart';
import 'package:expense_app/core/storage/sqflite.dart';
import 'package:expense_app/features/widgets/app_spinner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// First Flutter frame must paint immediately so Android can dismiss
  /// the native splash. Firebase / GetIt wait after that.
  runApp(const _StartupApp());
}

class _StartupApp extends StatefulWidget {
  const _StartupApp();

  @override
  State<_StartupApp> createState() => _StartupAppState();
}

class _StartupAppState extends State<_StartupApp> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      await _initFirebase();
      if (!sl.isRegistered<DBHelper>()) {
        await getITSetup();
      }
      if (!mounted) return;
      runApp(const MyApp());
    } catch (e, st) {
      debugPrint('Startup failed: $e\n$st');
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _initFirebase() async {
    try {
      if (Firebase.apps.isNotEmpty) return;
      await Firebase.initializeApp(
        options: _firebaseOptions(),
      ).timeout(const Duration(seconds: 12));
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') return;
      rethrow;
    }
  }

  FirebaseOptions _firebaseOptions() {
    if (!kIsWeb && Platform.isIOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBFASJA2gslayq5x-9LEVqwcDaNwE28rJc',
        appId: '1:660323074036:ios:4ccb9d27e5786a9f7f03a1',
        messagingSenderId: '660323074036',
        projectId: 'tictoegame-d1f4b',
        storageBucket: 'tictoegame-d1f4b.firebasestorage.app',
        iosBundleId: 'com.neonweb.expensioapp.app',
      );
    }
    return const FirebaseOptions(
      apiKey: 'AIzaSyADVsgLILrAwh57YUcShjbr2Zxb35PaBKw',
      appId: '1:660323074036:android:ed8e7e4c0a1fbd1e7f03a1',
      messagingSenderId: '660323074036',
      projectId: 'tictoegame-d1f4b',
      storageBucket: 'tictoegame-d1f4b.firebasestorage.app',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Center(
          child: _error == null
              ? const AppSpinner()
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not start app.\n$_error',
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.system,
          routerConfig: RouteGenerator.route,
        );
      },
    );
  }
}
