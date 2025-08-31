import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';

class ActionCircle extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onComplete;
  final bool filled;
  final Color color;
  final String text;

  const ActionCircle({
    required this.icon,
    required this.label,
    required this.onComplete,
    this.filled = false,
    this.text = '',
    this.color = Colors.green,
  });

  @override
  State<ActionCircle> createState() => ActionCircleState();
}

class ActionCircleState extends State<ActionCircle> {
  double progress = 0.0;
  Timer? _holdTimer;
  bool _holding = false;

  void _startHold() {
    _holding = true;
    progress = 0.0;
    const duration = Duration(milliseconds: 20);
    _holdTimer = Timer.periodic(duration, (timer) {
      setState(() {
        progress += 0.01;
      });
      if (progress >= 1.0) {
        _stopHold();
        widget.onComplete();
      }
    });
  }

  void _stopHold() {
    _holding = false;
    _holdTimer?.cancel();
    setState(() {
      progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startHold(),
      onLongPressEnd: (_) => _stopHold(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/clock.png",
                width: 16,
                color: const Color(0xff717680),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(widget.label,
                  style: context.textTheme.labelLarge
                      ?.copyWith(color: const Color(0xff717680))),
            ],
          ),
          const SizedBox(height: 27),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 106,
                width: 106,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.label == 'Clock out'
                        ? const Color(0xffB0334C)
                        : const Color(0xff00AD57), // outline color
                    width: 2,
                  ),
                  color: widget.label == 'Clock out'
                      ? const Color(0xffB0334C)
                      : Colors.transparent,
                ),
              ),
              Image.asset(
                widget.icon,
                height: 30,
                width: 34,
              ),
              if (_holding)
                SizedBox(
                  height: 116,
                  width: 116,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(
                        widget.label == 'Clock out'
                            ? const Color(0xffB0334C)
                            : const Color(0xff00AD57)),
                    backgroundColor: Colors.transparent,
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 21,
          ),
          Text(
            widget.text,
            style: context.textTheme.labelLarge
                ?.copyWith(color: const Color(0xff414141)),
          )
        ],
      ),
    );
  }
}
