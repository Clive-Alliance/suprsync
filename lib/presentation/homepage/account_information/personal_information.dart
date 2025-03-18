import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:image_picker/image_picker.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/presentation/homepage/account_information/account_controller.dart';
import 'package:suprsync/presentation/homepage/account_information/widgets/account_textfield.dart';

import '../auth/controller/auth_controller.dart';
import 'widgets/custom_list_tile.dart';

class PersonalInformation extends StatelessWidget {
  PersonalInformation({super.key});

  final AuthController _authController = Get.find();
  final AccountController _accountController = Get.find();

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController(
      text: _authController.firstName.value,
    );
    TextEditingController lastNameController = TextEditingController(
      text: _authController.lastName.value,
    );
    TextEditingController emailController = TextEditingController(
      text: _authController.email.value,
    );
    TextEditingController genderController = TextEditingController(
      text: _authController.gender.value.capitalizeFirst,
    );
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
          'Personal Information',
          style: context.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 28,
            ),
            // Fixed content at the top
            Obx(() {
              // Scrollable content in the middle
              return _authController.userDp.value.isEmpty
                  ? CircleAvatar(
                      radius: 38,
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
                      radius: 40,
                      backgroundColor: const Color(0xff59D1A0),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage:
                            NetworkImage(_authController.userDp.value),
                      ),
                    );
            }),

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
                        'First Name',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return AccountTextField(
                          // hintText: 'Enter password',
                          textEditingController: firstNameController,
                          isEnabled: _authController.isEditMode.value,
                          onChanged: (value) {
                            _authController.firstName(value);
                          },
                        );
                      }),
                      const SizedBox(height: 24),
                      Text(
                        'Last Name',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return AccountTextField(
                          // hintText: 'Enter password',
                          textEditingController: lastNameController,
                          isEnabled: _authController.isEditMode.value,
                          onChanged: (value) {
                            _authController.lastName(value);
                          },
                        );
                      }),
                      const SizedBox(height: 24),
                      Text(
                        'Email Address',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return AccountTextField(
                          // hintText: 'Gender',
                          textEditingController: emailController,
                          isEnabled: _authController.isEditMode.value,
                          onChanged: (value) {
                            _authController.email(value);
                          },
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Gender',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return AccountTextField(
                          // hintText: 'Enter password',
                          textEditingController: genderController,
                          isEnabled: _authController.isEditMode.value,
                          onChanged: (value) {
                            _authController.gender(value);
                          },
                        );
                      }),
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
              child: Obx(() {
                return RectangularButton(
                  onPress: () {
                    // Get.to(() => LoginBottomSheet());
                    //  _authController.isEditMode.value == true?
                    _authController.isEditMode.value =
                        !_authController.isEditMode.value;
                  },
                  buttonTitle: !_authController.isEditMode.value
                      ? 'Edit profile'
                      : 'Save changes',
                  verticalPadding: 0,
                  textStyleColor: const TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  colour: context.colorScheme.tertiary,
                  height: 44,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
