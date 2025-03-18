import 'package:flutter/material.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/date_utils.dart';
import 'package:suprsync/models/checkin_schedule_model.dart';

class CheckinListTile extends StatelessWidget {
  const CheckinListTile({
    super.key,
    required this.checkInScheduleModel,
    required this.range,
    required this.hoursWorked,
    required this.duration,
    required this.month,
  });

  final CheckInScheduleModel checkInScheduleModel;
  final String range;
  final String hoursWorked;
  final String duration;
  final String month;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffF9F8F8),
          border: Border.all(width: 1, color: const Color(0xffF5F5F5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$month ",
                      style: context.textTheme.labelMedium?.copyWith(
                        color: const Color(0xff727272),
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(hoursWorked,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              const VerticalDivider(
                width: 2,
                thickness: 2,
                color: Colors.black,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(duration,
                      style: context.textTheme.labelSmall?.copyWith(
                          color: const Color(
                            0xff000000,
                          ),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'In & out',
                    style: context.textTheme.labelMedium
                        ?.copyWith(color: const Color(0xff727272)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
