import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/shift_set.dart';
import 'package:suprsync/presentation/dashboard_screen/homepage.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_day_list.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_period_modal.dart';

class ShiftSetDaysPage extends GetView<ShiftSetController> {
  const ShiftSetDaysPage({super.key, this.replaceStackOnSave = false});

  /// Login opens this page with nothing underneath, so saving replaces the
  /// stack with home. Opening it from the schedule keeps the existing stack.
  final bool replaceStackOnSave;

  Future<void> _save() async {
    if (controller.selectedOffsets.isEmpty) {
      showSnackBar('Select at least one day');
      return;
    }
    if (controller.userId.isEmpty) {
      showSnackBar('Sign in again before saving your shift set');
      return;
    }
    try {
      final saved = await controller.save();
      if (!saved) {
        showSnackBar('Select at least one day');
        return;
      }
      showSnackBar('Shift set saved');
      if (replaceStackOnSave) {
        Get.offAll(() => const HomePage());
      } else {
        Get.until((route) => route.isFirst);
      }
    } catch (error) {
      showSnackBar(readableShiftSetError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: Get.back,
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
              ),
              const SizedBox(height: 24),
              Text(
                'Which days can you work?',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff2C2C2C),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  final currentPeriod = controller.period.value;
                  final selected = controller.selectedOffsets.length;
                  final label = selected == 1
                      ? '1 day selected'
                      : '$selected days selected';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPeriod?.cadence ??
                            'Select the days you are available.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff6D6A6A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showShiftSetPeriodModal(
                            onNext: (period) => controller.prepare(
                              period,
                              keepCurrentSelection: true,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          currentPeriod == null
                              ? 'Choose a period'
                              : 'Change period · ${currentPeriod.label}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: const Color(0xff00AD57),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: const Color(0xff056033),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: ShiftSetDayList(
                          days: controller.days,
                          selectedOffsets: controller.selectedOffsets.toSet(),
                          repeat: currentPeriod?.repeat ??
                              ShiftSetRepeat.cycleOffset,
                          onToggle: controller.toggle,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Obx(
                () => RectangularButton(
                  onPress: controller.isSaving.value ? () {} : _save,
                  buttonTitle:
                      controller.isSaving.value ? 'Saving...' : 'Save',
                  height: 50,
                  colour: const Color(0xff00AD57),
                  textStyleColor: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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

String readableShiftSetError(Object error) {
  if (error is Map) {
    final body = error['body'];
    if (body is String && body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['message'] is String) {
          return decoded['message'] as String;
        }
      } catch (_) {
        return body;
      }
      return body;
    }
  }
  final text = error.toString().trim();
  if (text.isEmpty) return 'Could not save your shift set';
  return text;
}
