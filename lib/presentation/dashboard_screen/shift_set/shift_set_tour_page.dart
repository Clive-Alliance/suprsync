import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/presentation/dashboard_screen/homepage.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_days_page.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_period_modal.dart';

class ShiftSetTourPage extends GetView<ShiftSetController> {
  const ShiftSetTourPage({super.key});

  void _start(BuildContext context) {
    final replaceStack = !Navigator.of(context).canPop();
    showShiftSetPeriodModal(
      onNext: (period) {
        controller.prepare(period);
        Get.to(
          () => ShiftSetDaysPage(replaceStackOnSave: replaceStack),
        );
      },
    );
  }

  void _leave(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final canLeave = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (canLeave)
                InkWell(
                  onTap: () => _leave(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/arrow-left.png',
                        width: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Back',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),
                      Image.asset(
                        AppIcons.calendarOutline,
                        height: 56,
                        color: const Color(0xff056033),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Set your Shift Set',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xff2C2C2C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A shift set is the days you can work, repeated over a week, two weeks, or a month. We ask once, then keep the pattern for scheduling.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff6D6A6A),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _Step(
                        number: '1',
                        text: 'Choose how long the set lasts.',
                      ),
                      const _Step(
                        number: '2',
                        text: 'Tap every day you are available to work.',
                      ),
                      const _Step(
                        number: '3',
                        text: 'Save. The same days repeat on the next cycle.',
                      ),
                    ],
                  ),
                ),
              ),
              RectangularButton(
                onPress: () => _start(context),
                buttonTitle: 'Start',
                height: 50,
                colour: const Color(0xff00AD57),
                textStyleColor: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => _leave(context),
                  child: Text(
                    'Not now',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xff6D6A6A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xffEBFFF5),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff056033),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff2C2C2C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
