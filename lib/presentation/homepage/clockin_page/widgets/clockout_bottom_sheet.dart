import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/app_textfield.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';

typedef StringCallback = void Function(String);

class ClockoutBottomSheet extends StatefulWidget {
  const ClockoutBottomSheet(
      {super.key, required this.onToggle, required this.duration});
  final StringCallback onToggle;
  final Duration duration;

  @override
  State<ClockoutBottomSheet> createState() => _ClockoutBottomSheetState();
}

class _ClockoutBottomSheetState extends State<ClockoutBottomSheet> {
  final AuthController _authController = Get.find();
  ClockInAndOutController _clockOutController = Get.find();

  final TextEditingController _checkOutController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: Get.height * 0.59,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // AppBar Section
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Confirm checkout',
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              color: Color(0xffEAEAEA),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Text
                  const SizedBox(height: 20),

                  const Text(
                    'Hours worked',
                    style: TextStyle(fontSize: 14, color: Color(0xff6D6A6A)),
                  ),
                  Text(
                    '${widget.duration.toString().substring(0, 7)} hrs',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overtime',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff6D6A6A)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'N/A',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 74,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Double Shift',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff6D6A6A)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'N/A',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Add Notes Section
                  const Row(
                    children: [
                      Text(
                        'Add notes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6D6A6A),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '(optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff6D6A6A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Text Field
                  CustomAuthTextField(
                    hintText: 'Write note',
                    textEditingController: _checkOutController,
                    maxLine: 5,
                  ),
                  const SizedBox(height: 32),
                  // Button Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TransparentRectangularButton(
                          onPress: () {
                            Get.back();
                            // Add your login logic here
                          },
                          buttonTitle: 'Cancel',
                          textStyleColor: context.textTheme.labelLarge
                              ?.copyWith(color: const Color(0xff000000)),
                          colour: const Color(0xff000000),
                          height: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: RectangularButton(
                          onPress: () async {
                            await _clockOutController.clockOutController(
                              'clockOut',
                            );
                            // Get.back();

                            widget.onToggle('Confirm');
                            // Add your login logic here
                          },
                          buttonTitle: 'Confirm',
                          textStyleColor: context.textTheme.labelLarge
                              ?.copyWith(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.w700),
                          colour: context.colorScheme.tertiary,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
