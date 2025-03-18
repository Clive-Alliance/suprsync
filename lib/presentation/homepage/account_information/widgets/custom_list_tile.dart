import 'package:flutter/material.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onTap,
      this.subTitle = '',
      this.trailingIcon});
  final Widget leadingIcon;
  final Widget? trailingIcon;
  final String? subTitle;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        horizontalTitleGap: 0,
        onTap: onTap,
        leading: leadingIcon,
        trailing: trailingIcon ?? const SizedBox(),
        title: Text(
          title,
          style: context.textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subTitle.toString(),
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0xff898585),
            )));
  }
}
