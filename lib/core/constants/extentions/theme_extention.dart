import 'package:flutter/material.dart';

extension XBuildContext<T> on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Color? get textColor => theme.textTheme.bodyMedium?.color;
  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get edgeInsets => MediaQuery.viewPaddingOf(this);
  RoundedRectangleBorder get modalShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      );
}
