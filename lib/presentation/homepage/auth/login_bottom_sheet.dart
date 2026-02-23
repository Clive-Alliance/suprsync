import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/app_textfield.dart';
import '../../dashboard_screen/auth/controller/auth_controller.dart';
import 'auth_page.dart';
// import 'controller/auth_controller.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({
    super.key,
  });

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final AuthController _authController = Get.find();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
        height: 556,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              AppIcons.ss,
              height: 43.75,
              width: 31.14,
            ),
            const SizedBox(
              height: 28,
            ),
            Text(
              'Welcome Back to SuprSync',
              style: context.textTheme.headlineSmall?.copyWith(
                  // color: context.colorScheme.onSurface, fontFamily: 'Freight'
                  ),
            ),
            const SizedBox(height: 9),
            Text('Enter your credentials to access your account.',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff6D6A6A))),
            const SizedBox(
              height: 35,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Address',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xff000000),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomAuthTextField(
                    hintText: 'Enter email address',
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Password',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xff000000),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomAuthTextField(
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye)),
                    obscureText: !isVisible,
                    textEditingController: _passwordController,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: (){
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: BoxBorder.all(color: Colors.grey)
                        ),
                        child: rememberMe ? Center(child: Icon(Icons.check, color: Colors.green, size: 16,)) : null,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Remember me?',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                    showForgotPasswordSheet(context);
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Color(0xffD9694D),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Circular',
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            RectangularButton(
              onPress: () {
                // _authController.signIn('aotegbeye', 'ayodejiotegbeye');
                _authController.signIn(_emailController.text, _passwordController.text, rememberMe);

                // Get.to(() => HomePage());

                // if (_emailController.text.isEmpty ||
                //     _passwordController.text.isEmpty) {
                //   showSnackBar('Enter an email or password');
                // } else if (_emailController.text.isNotEmpty &&
                //     _passwordController.text.isNotEmpty) {
                // _authController.signIn(
                //     _emailController.text, _passwordController.text);
                // }
              },
              buttonTitle: 'Login',
              textStyleColor: context.textTheme.labelLarge
                  ?.copyWith(color: context.colorScheme.secondary),
              colour: context.colorScheme.tertiary,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
