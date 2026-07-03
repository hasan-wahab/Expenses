import 'package:expense_app/core/extensions/context_extension.dart';
import 'package:expense_app/features/widgets/priamary_butn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_android/local_auth_android.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: SizedBox(
        height: .infinity,
        width: .infinity,
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            PrimaryButton(
              text: 'Login With Finger Prints',
              onTap: () async {
                try
                {
                  LocalAuthentication local = LocalAuthentication();
                  bool checkingDevice = await local.isDeviceSupported();
                  print(checkingDevice);
                  bool check = await local.authenticate(
                    localizedReason: 'Use your fingerprint to log in',
                    persistAcrossBackgrounding: true,
                    biometricOnly: true,
                  );

                  print(check);
                }
                on PlatformException catch (e) {
                  context.showSnackBar('Device not suppoeted');
                } on LocalAuthException catch (e)
                {
                  if (e.code == LocalAuthExceptionCode.unknownError) {
                    context.showSnackBar(
                      'Please add finger in your device settings',
                    );
                  } else if (e.code ==
                          LocalAuthExceptionCode.temporaryLockout ||
                      e.code == LocalAuthExceptionCode.biometricLockout) {
                    // ...
                    context.showSnackBar(
                      'Please add finger in your device settings2',
                    );
                  } else if (e.code ==
                      LocalAuthExceptionCode.noBiometricsEnrolled) {
                    // ...
                    context.showSnackBar(
                      'Please add finger in your device settings1',
                    );
                  } else {
                    print('object');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
