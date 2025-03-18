import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_page.dart';
import 'package:suprsync/presentation/homepage/schedules/swap_screen.dart';

class SwapCard extends StatelessWidget {
  const SwapCard(
      {super.key,
      required this.isActive,
      required this.time,
      required this.day,
      required this.id,
      this.isOpenForSwap = false,
      required this.title,
      required this.branch,
      required this.hexcode,
      required this.initials});
  final String title;
  final bool isActive;
  final String id;
  final String time;
  final String day;
  final bool isOpenForSwap;
  final String branch;
  final String hexcode;
  final String initials;
  @override
  Widget build(BuildContext context) {
    final ClockInAndOutController _clockInController = Get.find();
    final AuthController _authController = Get.find();

    return Card(
      color: const Color(0xffFBFBFB),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Color(0xffF5F5F5))),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 19,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
                child: VerticalDivider(
                  color: Colors.black,
                  width: 5,
                  thickness: 8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time.removeAllWhitespace,
                      style: context.textTheme.labelMedium
                          ?.copyWith(color: const Color(0xE59A9A9A)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      day,
                      style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8E8E90)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // NetworkImage(_authController.userDp.value),
                        _authController.userAuth.value!.user!.picture != null
                            ? CircleAvatar(
                                foregroundImage: NetworkImage(_authController
                                    .userAuth.value!.user!.picture!.url
                                    .toString()),
                                // backgroundColor: Color(hexcode)
                              )
                            : CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xff00AD57),
                                child: Text(
                                  initials.removeAllWhitespace,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          title,
                          style: context.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        // Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/Map Point Wave.png',
                            width: 17,
                            color: Color(
                              int.parse(hexcode),
                            )),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          branch,
                          style: context.textTheme.labelSmall
                              ?.copyWith(color: Color(int.parse(hexcode))),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    _clockInController.shiftId.value;
                    return IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        print(
                            'show pop up ${_clockInController.shiftId.value}');
                        // _showSwapShiftDialog(context);
                        _clockInController.shiftId.value = id;
                        print(
                            'show pop up 2${_clockInController.shiftId.value}');
                        _showPopupMenu(context,
                            _clockInController.shiftId.value, isOpenForSwap);
                      },
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  !isOpenForSwap
                      ? Obx(() {
                          _clockInController.swapId.value;
                          return GestureDetector(
                            onTap: () {
                              _clockInController.swapId.value = id;
                              // Get.to(() => const SwapScreen());
                            },
                            child: Container(
                              color: const Color(0xffFFFFFF),
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 14),
                                child: Text(
                                  isOpenForSwap
                                      ? 'Open for Swap'
                                      : 'Closed for swap',
                                  style: context.textTheme.labelMedium,
                                ),
                              ),
                            ),
                          );
                        })
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, shiftId, isSwappable) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final buttonWidth = renderBox.size.width;
    final buttonHeight = renderBox.size.height - 100;
    print('your shift Id 2 is $shiftId');

    // Show the menu to the right of the button
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx +
            buttonWidth, // Shift the menu to the right by button width
        position.dy + buttonHeight, // Keep the same vertical position
        0, // No space on the right side
        0, // No space on the bottom side
      ),
      color: Colors.white,
      items: [
        PopupMenuItem(
          onTap: () {
            print('your shift Id is $shiftId');

            Get.to(() => ClockInPage(id: shiftId));
          },
          value: 'Clock In',
          child: Text('Clock In',
              style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400, color: const Color(0xff000000))),
        ),
        PopupMenuItem(
          onTap: () {
            if (isSwappable) {
              // Get.to(() => SwapScreen());
            } else {
              showSnackBar('This shift is not swappable');
            }
          },
          value: 'Swap',
          child: Text('Swap',
              style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400, color: const Color(0xff000000))),
        ),
        // PopupMenuItem(
        //   value: 'option3',
        //   child: Text('Option 3'),
        // ),
      ],
      elevation: 8.0,
    );
  }
}

class SwappableShifts extends StatelessWidget {
  const SwappableShifts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text('Open shifts for swap')],
    );
  }
}
