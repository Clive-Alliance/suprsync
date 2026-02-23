import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:suprsync/core/theme/app_theme.dart';
import 'package:suprsync/presentation/controllers/items_controller.dart';
import 'package:suprsync/presentation/controllers/transfer_controllers.dart';
import 'package:suprsync/presentation/dashboard_screen/account_information/account_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/auth_page.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/calendar/calendar_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/clockin_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_controller/withdrawal_controller.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:suprsync/services/auth_service.dart';
import 'package:suprsync/util/persistor/data_persistor.dart';
import 'firebase/live/firebase_options.dart' as live;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this
  await Firebase.initializeApp(
    name: 'suprsync',
    options: live.DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  // await FaceCamera.initialize();
  Get.put(AuthController(), permanent: true);
  Get.put(ClockInAndOutController(), permanent: true);
  Get.put(ShiftController(), permanent: true);
  Get.put(AccountController(), permanent: true);
  Get.put(CalendarController(), permanent: true);
  Get.put(WithdrawalController(), permanent: true);
  Get.put(ItemsController(), permanent: true);
  Get.put(TransferController(), permanent: true);

  await SentryFlutter.init((options) {
    options.dsn = 'https://e7302a2c5e4d31bc6bd30a0502d45a7d@o4510777399836672.ingest.de.sentry.io/4510777403375696';
    options.sendDefaultPii = true;
  },
    appRunner: () => runApp(
      CalendarControllerProvider(
        controller: EventController(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Authentication _authentication = Authentication();

  void checkToken(){
    DataPersistor.getLoginTime().then((time){
      if(DateTime.now().isAfter(time ?? DateTime.now())){
        DataPersistor.getRefreshToken().then((token){
          if(token.isNotEmpty) {
            _authentication.refreshToken(token);
          }
        });
      }
    });
  }

  @override
  void initState() {
    checkToken();
    super.initState();
  }

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
