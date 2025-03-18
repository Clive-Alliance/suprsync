import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/presentation/homepage/account_information/password_and_security.dart.dart';
import 'package:suprsync/presentation/homepage/account_information/personal_information.dart';
import 'package:suprsync/presentation/homepage/account_information/widgets/logout_dialog.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';

import '../../../core/constants/app_images.dart';
import 'widgets/custom_list_tile.dart';

class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({super.key});
  @override
  Widget build(BuildContext context) {
    AuthController _authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 0,
        title: Text(
          'Account',
          style: context.textTheme.titleMedium,
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Obx(() {
                  // Scrollable content in the middle
                  return _authController.userDp.value.isEmpty
                      ? CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xff00AD57),
                          child: Text(
                            "${_authController.firstName.substring(0, 1)} ${_authController.lastName.substring(0, 1)}",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xff59D1A0),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                NetworkImage(_authController.userDp.value),
                          ),
                        );
                }),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Text(
                        '${_authController.firstName.value} ${_authController.lastName.value}',
                        // '${widget.userAuth.user!.firstName} ${widget.userAuth.user!.lastName}',
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context.colorScheme.onSurface),
                      );
                    }),
                    Text(
                      _authController.email.value,
                      // ${widget.userAuth.user!.email}

                      style: context.textTheme.labelMedium
                          ?.copyWith(color: const Color(0xff868787)),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.profile,
              height: 20,
            ),
            title: 'Personal Information',
            trailingIcon: Image.asset(
              AppIcons.rightChevron,
              height: 13,
              color: const Color(0xffBBBABA),
            ),
            onTap: () {
              Get.to(() => PersonalInformation());
            },
          ),
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.security,
              height: 20,
            ),
            title: 'Password & Security',
            trailingIcon: Image.asset(
              AppIcons.rightChevron,
              height: 13,
              color: const Color(0xffBBBABA),
            ),
            onTap: () {
              Get.to(() => PasswordAndSecurity());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Others',
              style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500, color: const Color(0xff6F6F6F)),
            ),
          ),
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.faq,
              height: 20,
            ),
            title: 'FAQ',
            trailingIcon: Image.asset(
              AppIcons.rightChevron,
              height: 13,
              color: const Color(0xffBBBABA),
            ),
            onTap: () {
              // Get.to(() => ChangePasswordPage());
            },
          ),
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.signout,
              height: 20,
            ),
            title: 'Sign out',
            // trailingIcon: Image.asset(
            //   AppIcons.rightChevron,
            //   height: 13,
            //   color: const Color(0xffBBBABA),
            // ),
            onTap: () {
              // Get.to(() => ChangePasswordPage());
              showLogoutDialog(context);
            },
          ),
          // CustomListTile(
          //   leadingIcon: AppIcons.languageCircle,
          //   title: 'Language',
          //   trailingIcon: AppIcons.arrowRight,
          //   onTap: () {
          //     Get.to(() => const ChangeLanguagePage());
          //   },
          // ),
          // CustomListTile(
          //   leadingIcon: AppIcons.devices,
          //   title: 'Sessions',
          //   trailingIcon: AppIcons.arrowRight,
          //   onTap: () {
          //     Get.to(() => const CurrentSessionsPage());
          //   },
          // ),
          // CustomListTile(
          //   leadingIcon: AppIcons.logOut,
          //   title: 'Log out',
          //   onTap: () {
          //     Get.off(const LoginScreen());
          //   },
          // )
        ],
      ),
    );
    ;
  }
}
