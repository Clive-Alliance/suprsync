import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  const RectangularButton(
      {super.key,
      this.colour,
      this.buttonTitle,
      this.onPress,
      this.isLoading = false,
      this.textStyleColor,
      this.verticalPadding,
      this.height});

  final Color? colour;
  final String? buttonTitle;
  final void Function()? onPress;
  final TextStyle? textStyleColor;
  final double? height;
  final bool? isLoading;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        // margin: const EdgeInsets.only(left: 32, right: 32, bottom: 47),
        // padding: const EdgeInsets.symmetric(vertical: 8.0),
        margin: EdgeInsets.symmetric(vertical: verticalPadding ?? 20.0),
        height: height,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0), color: colour),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonTitle!,
              style: textStyleColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TransparentRectangularButton extends StatelessWidget {
  const TransparentRectangularButton(
      {super.key,
      this.colour,
      this.buttonTitle,
      this.onPress,
      this.isLoading = false,
      this.textStyleColor,
      this.verticalPadding,
      this.height});

  final Color? colour;
  final String? buttonTitle;
  final void Function()? onPress;
  final TextStyle? textStyleColor;
  final double? height;
  final bool? isLoading;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        // margin: const EdgeInsets.only(left: 32, right: 32, bottom: 47),
        // padding: const EdgeInsets.symmetric(vertical: 8.0),
        margin: EdgeInsets.symmetric(vertical: verticalPadding ?? 20.0),
        height: height,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            border: Border.all(color: Color(0xff707070), width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonTitle!,
              style: textStyleColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
