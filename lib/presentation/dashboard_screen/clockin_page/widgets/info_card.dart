import 'package:flutter/material.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/presentation/dashboard_screen/clockin_page/clockin_controller.dart';

class InfoCard extends StatelessWidget {
  final String message;
  final InfoType type;

  const InfoCard({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    String icon;

    switch (type) {
      case InfoType.success:
        icon = AppIcons.clockedIn;
        break;
      case InfoType.error:
        icon = AppIcons.cannotClockin;
        break;
      default:
        return const SizedBox.shrink(); // nothing to show
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        border: Border.all(color: const Color(0xffE9EAEB), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 21, top: 15, bottom: 15),
            child: Image.asset(
              icon,
              height: 60,
            ),
          ),
          Container(
            width: 1,
            height: 60, // match image height or card height
            color: const Color(0xffE9EAEB),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 24, top: 15, bottom: 15),
              child: Text(
                message,
                style: context.textTheme.labelSmall?.copyWith(
                  color: const Color(0xff717680),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
