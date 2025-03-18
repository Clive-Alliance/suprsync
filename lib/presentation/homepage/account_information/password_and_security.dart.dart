// import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/presentation/homepage/account_information/register_face.dart';
import 'package:suprsync/presentation/homepage/account_information/widgets/account_textfield.dart';

import 'widgets/custom_list_tile.dart';

// @RoutePage()

class PasswordAndSecurity extends StatelessWidget {
  const PasswordAndSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: AppIcons.arrowLeft),
        titleSpacing: 0,
        title: Text(
          'Passwords & Security',
          style: context.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.security,
              height: 20,
            ),
            title: 'Change Password',
            trailingIcon: Image.asset(
              AppIcons.rightChevron,
              height: 20,
              color: const Color(0xffBBBABA),
            ),
            onTap: () {
              Get.to(() => ChangePasswordPage());
            },
          ),
          CustomListTile(
            leadingIcon: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                AppIcons.scanner,
                height: 20,
              ),
            ),
            title: 'Face ID',
            subTitle: 'inactive',
            trailingIcon: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                AppIcons.rightChevron,
                height: 20,
                color: const Color(0xffBBBABA),
              ),
            ),
            onTap: () {
              Get.to(() => FaceIdScreen());
            },
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: AppIcons.arrowLeft),
        titleSpacing: 0,
        title: Text(
          'Change password',
          style: context.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed content at the top

            // Scrollable content in the middle
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Current Password',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AccountTextField(
                        hintText: 'Enter password',
                        textEditingController: currentPasswordController,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'New password',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AccountTextField(
                        hintText: 'Enter password',
                        textEditingController: currentPasswordController,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Confirm new password',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AccountTextField(
                        hintText: 'Enter password',
                        textEditingController: currentPasswordController,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            // Fixed button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: RectangularButton(
                onPress: () {
                  // Get.to(() => LoginBottomSheet());
                },
                buttonTitle: 'Save changes',
                verticalPadding: 0,
                textStyleColor: const TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                colour: context.colorScheme.tertiary,
                height: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaceIdScreen extends StatefulWidget {
  const FaceIdScreen({super.key});

  @override
  State<FaceIdScreen> createState() => _FaceIdScreenState();
}

class _FaceIdScreenState extends State<FaceIdScreen> {
  bool isActivated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: AppIcons.arrowLeft),
        titleSpacing: 0,
        title: Text(
          'Face ID',
          style: context.textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.security,
              height: 20,
            ),
            title: 'Register facial data',
            onTap: () {
              Get.to(() => ChangePasswordPage());
            },
          ),
          CustomListTile(
            leadingIcon: Image.asset(
              AppIcons.scanner,
              height: 20,
            ),
            title: 'Activate Face ID',
            trailingIcon: SizedBox(
              height: 20,
              width: 37,
              child: CupertinoSwitch(
                  value: isActivated,
                  onChanged: (value) {
                    print(value);
                    isActivated = !isActivated;
                  }),
            ),
            onTap: () {
              Get.to(() => const FaceRegistration());
            },
          ),
        ],
      ),
    );
    ;
  }
}
