import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftCard extends StatelessWidget {
  const ShiftCard({
    super.key,
    required this.time,
    required this.day,
    required this.id,
    required this.branch,
    required this.hexCode,
  });

  final String id;
  final String time;
  final String day;
  final String branch;
  final String hexCode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 0,
      color: const Color(0xffFBFBFB),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(color: Color(0xffF5F5F5))),
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
              padding: const EdgeInsets.only(left: 13.0, top: 13),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '8hrs',
                        style: context.textTheme.titleMedium?.copyWith(
                            fontSize: 14, color: const Color(0xff8E8E90)),
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                      ),
                      Text(
                        branch,
                        style: context.textTheme.labelSmall
                            ?.copyWith(color: Color(int.parse("0xff$hexCode"))),
                        // textAlign: Ali,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
