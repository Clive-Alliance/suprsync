import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/models/shift_set.dart';

Future<void> showShiftSetPeriodModal({
  required ValueChanged<ShiftSetPeriod> onNext,
}) {
  return Get.dialog(
    ShiftSetPeriodDialog(onNext: onNext),
    barrierDismissible: true,
  );
}

class ShiftSetPeriodDialog extends StatefulWidget {
  const ShiftSetPeriodDialog({super.key, required this.onNext});

  final ValueChanged<ShiftSetPeriod> onNext;

  @override
  State<ShiftSetPeriodDialog> createState() => _ShiftSetPeriodDialogState();
}

class _ShiftSetPeriodDialogState extends State<ShiftSetPeriodDialog> {
  ShiftSetPeriod? _selected;

  void _confirm() {
    final chosen = _selected;
    if (chosen == null) return;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
    widget.onNext(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height * 0.82),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How long should this shift set run?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose the period your availability repeats over.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6D6A6A),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final period in ShiftSetPeriod.values)
                        _PeriodOption(
                          period: period,
                          selected: _selected == period,
                          onTap: () => setState(() => _selected = period),
                        ),
                    ],
                  ),
                ),
              ),
              RectangularButton(
                onPress: _selected == null ? () {} : _confirm,
                buttonTitle: 'Next',
                height: 50,
                colour: _selected == null
                    ? const Color(0xffD0D0D0)
                    : const Color(0xff00AD57),
                textStyleColor: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodOption extends StatelessWidget {
  const _PeriodOption({
    required this.period,
    required this.selected,
    required this.onTap,
  });

  final ShiftSetPeriod period;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? const Color(0xffEBFFF5) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('shift-period-${period.key}'),
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? const Color(0xff00AD57)
                    : const Color(0xffE6E6E6),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected
                      ? const Color(0xff00AD57)
                      : const Color(0xffC8C8C8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        period.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        period.description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: Color(0xff6D6A6A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
