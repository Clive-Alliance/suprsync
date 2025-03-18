import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:get/route_manager.dart';
import 'package:suprsync/core/constants/app_images.dart';

import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/app_textfield.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/auth/login_bottom_sheet.dart';
import 'package:suprsync/presentation/homepage/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AuthController _authController = Get.find();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // _authController.loadDetails();
      Get.to(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/snapshot_splash.png'),
                fit: BoxFit.fill)),
        child: Center(
          child: Image.asset(
            AppIcons.ssLogo,
            width: 103.94,
            height: 88.22,
          ),
        ),
      ),
    );
  }
}

void showLoginBottomSheet(BuildContext context) {
  // final ValueCallback onValueSelected;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // AuthController _authController = AuthController();
  bool isVisible = false;

  Size size = MediaQuery.of(context).size;
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: context.colorScheme.secondary,
      context: context,
      builder: (BuildContext context) {
        return LoginBottomSheet(
            // emailController: _emailController,
            // // isVisible: isVisible,
            // passwordController: _passwordController,
            // authController: _authController
            );
      });
}

void showForgotPasswordSheet(BuildContext context) {
  // final ValueCallback onValueSelected;
  // Size size = MediaQuery.of(context).size;
  // AuthController _authController = Get.find();
  TextEditingController _emailController = TextEditingController();
  AuthController _authController = Get.find();
  showModalBottomSheet(
      isScrollControlled: true,
      // enableDrag: true,
      backgroundColor: context.colorScheme.secondary,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
            height: 515,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        showLoginBottomSheet(context);
                      },
                      child: Image.asset(
                        'assets/icons/arrow-left.png',
                        width: 16,
                        // height: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Back',
                      style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppIcons.ss,
                      width: 31.14,
                      height: 43.75,
                    )
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Forgot your Password?',
                  style: context.textTheme.headlineSmall?.copyWith(
                      color: Color(0xff000000), fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                    'Having trouble remembering your password?\nNo worries, it happens to the best of us! Let\'s get you\nback into your account quickly.',
                    style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0xff6D6A6A),
                        fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomAuthTextField(
                  hintText: 'Enter email address',
                  textEditingController: _emailController,
                ),
                const Expanded(child: SizedBox()),
                RectangularButton(
                  onPress: () {
                    if (_emailController.text.isEmpty) {
                      showSnackBar('Enter a valid Email');
                    } else {
                      showResetPasswordLink(context);
                      _authController.forgotPassword(_emailController.text);
                    }

                    // } else {
                    //   showSnackBar('Enter a valid email');
                    // }
                  },
                  buttonTitle: 'Recover password',
                  textStyleColor: context.textTheme.labelLarge
                      ?.copyWith(color: Color(0xffffffff)),
                  colour: context.colorScheme.tertiary,
                  height: 50,
                )
              ],
            ),
          ),
        );
      });
}

//Todo

showResetPasswordLink(context) {
  Get.dialog(Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 350,
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        // size.width,
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/email-sent-YcLADRq6sP.png',
              width: 100,
              // height: ,
              // height: 52,
            ),
            SizedBox(
              height: 50,
            ),
            const Text("Reset password link sent",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2C2C2C))),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Reset password link has been sent to your email.",
              style: TextStyle(
                // fontSize: 12,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: RectangularButton(
                onPress: () {
                  Get.back();

                  showLoginBottomSheet(context); // onTapFunction();
                },
                buttonTitle: "Go back to login",
                height: 40,
                colour: const Color(0xff00AD57),
                textStyleColor: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Didn\'t receive mail?'),
                const SizedBox(
                  width: 3,
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Click to Resend',
                    style: TextStyle(color: Color(0xff00AD57)),
                  ),
                )
              ],
            )
          ],
        ),
      )));
}
