import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suprsync/core/theme/app_theme.dart';
import 'package:suprsync/presentation/controllers/items_controller.dart';
import 'package:suprsync/presentation/controllers/transfer_controllers.dart';
import 'package:suprsync/presentation/homepage/account_information/account_controller.dart';

import 'package:suprsync/presentation/homepage/auth/auth_page.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';
import 'package:suprsync/presentation/homepage/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_controller/withdrawal_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this

  // await FaceCamera.initialize();
  Get.put(AuthController(), permanent: true);
  Get.put(ClockInAndOutController(), permanent: true);
  Get.put(ShiftController(), permanent: true);
  Get.put(AccountController(), permanent: true);
  Get.put(CalendarController(), permanent: true);
  Get.put(WithdrawalController(), permanent: true);
  Get.put(ItemsController(), permanent: true);
  Get.put(TransferController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      // themeMode: ThemeService()
      //     .theme, // GetX theme service for dynamic theme switching
      // Navigation setup with GetX
      // initialRoute: AppRouter.initialRoute,
      // getPages: AppRouter.routes,
      // Analytics tracking
      // navigatorObservers: [Get.put(FirebaseAnalyticsObserver())],
      home: SplashScreen(),
      // home: FaceDetectionScreen(),
    );
  }
}
