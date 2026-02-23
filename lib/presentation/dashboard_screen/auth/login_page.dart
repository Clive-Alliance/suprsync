import 'package:flutter/material.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import '../../homepage/auth/auth_page.dart';
import 'auth_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: MediaQuery.of(context).size.height * .55,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_screen_image.png'),
                    fit: BoxFit.fill)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 27,
                ),
                Text(
                  'Manage Your\nSchedule Seamlessly\nwith Suprsync',
                  style: context.textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'With Suprsync, stay on top of your schedule like\nnever before. View all your assigned tasks in one\nplace, mark days when you’re unavailable, and \neasily request time off.',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: const Color(0xff6D6A6A)),
                ),
                const SizedBox(
                  height: 30,
                ),
                RectangularButton(
                  onPress: () {
                    // Get.to(() => LoginBottomSheet());
                    showLoginBottomSheet(context);
                    // Get.to(
                    //     () => DayGrid(lastPeriodDate: DateTime(2024, 12, 16)));
                  },
                  buttonTitle: 'Login',
                  textStyleColor: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  colour: context.colorScheme.tertiary,
                  height: 50,
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
