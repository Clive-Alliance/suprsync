import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:intl/intl.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/presentation/homepage/calendar/calendar_controller.dart';

class RequestTimeOffScreen extends StatefulWidget {
  const RequestTimeOffScreen({super.key});

  @override
  _RequestTimeOffScreenState createState() => _RequestTimeOffScreenState();
}

class _RequestTimeOffScreenState extends State<RequestTimeOffScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _reasonController = TextEditingController();
  final CalendarController _calendarController = CalendarController();
  List<bool> isSelected = [false, false];

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff00AD57), // Header color
            // accentColor: Colors.deepPurple, // Selected date circle color
            colorScheme: const ColorScheme.light(
              primary: Color(0xff00AD57), // Header and selected date color
              onPrimary: Colors.white, // Text color on header
              onSurface: Colors.black, // Body text color
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          isSelected[0] = true;
          _fromDate = picked;
        } else {
          isSelected[1] = true;

          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  'assets/icons/arrow-left.png',
                  width: 18,
                  // height: 18,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Back',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff000000)),
              )
            ],
          ),
        ),
        title: Text(
          "Request Time-Off",
          style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600, color: const Color(0xff2C2C2C)),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height, // Minimum height constraint
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Duration of time-off",
                  style: context.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: context.textTheme.labelMedium,
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context, true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _fromDate != null
                                        ? DateFormat('d MMM, yyyy')
                                            .format(_fromDate!)
                                        : "Select date",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: isSelected[0]
                                                ? Color(0xff000000)
                                                : Color(0xffABABAB)),
                                  ),
                                  Image.asset(
                                    AppIcons.calendarOutline,
                                    height: 18,
                                    color: isSelected[0]
                                        ? const Color(0xff00AD57)
                                        : const Color(0xff000000),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: context.textTheme.labelMedium,
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _toDate != null
                                        ? DateFormat('d MMM, yyyy')
                                            .format(_toDate!)
                                        : "Select date",
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: isSelected[1]
                                                ? Color(0xff000000)
                                                : Color(0xffABABAB)),
                                  ),
                                  Image.asset(
                                    AppIcons.calendarOutline,
                                    height: 18,
                                    color: isSelected[1]
                                        ? const Color(0xff00AD57)
                                        : const Color(0xff000000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xffDEDEDE),
                        width: 1.0), // Border for the dropdown
                    borderRadius: BorderRadius.circular(5.0), // Rounded corners
                  ),
                  child: Obx(() {
                    return DropdownButton<String>(
                      value: _calendarController.selectedItem.value,
                      hint: Text(
                        "Choose Vacation type",
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: Color(0xffABABAB)),
                      ),
                      // Placeholder text
                      dropdownColor: Colors.white,
                      padding: EdgeInsets.zero,
                      style: context.textTheme.bodyMedium,
                      underline: SizedBox(), // Remove the default underline
                      isExpanded:
                          true, // Makes the dropdown expand to the container width
                      items: _calendarController.items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: context.textTheme.bodySmall,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          _calendarController.selectItem(
                              value); // Call the controller's method
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Reason for time-off",
                  style: context.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  // initialValue: initialValue,
                  textCapitalization: TextCapitalization
                      .sentences, // Capitalizes the first letter of each senten                  // readOnly: readOnly,
                  // onTap: onTap,
                  maxLines: 5,

                  onChanged: (string) {},
                  style: context.textTheme.bodySmall,

                  obscuringCharacter: '*',
                  autocorrect: true,
                  decoration: InputDecoration(
                    filled: false,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Enter Reason',
                    hintStyle: context.textTheme.labelMedium
                        ?.copyWith(color: const Color(0xffDEDEDE)),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffDEDEDE), width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xffDEDEDE), width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                // const Spacer(),
                const Divider(
                  height: 2,
                  thickness: 1,
                ),
                Obx(() {
                  _calendarController.reason.value;
                  return RectangularButton(
                    onPress: () async {
                      if (_fromDate == null) {
                        showSnackBar('Select a start date');
                      } else if (_toDate == null) {
                        showSnackBar('select an end Date');
                      } else if (!_calendarController.itemSelected.value) {
                        showSnackBar('select a vacation type');
                      } else if (_reasonController.text.isEmpty) {
                        showSnackBar('Enter a reason');
                      } else {
                        String startDate =
                            DateFormat('yyyy-MM-dd').format(_fromDate!);
                        String endDate =
                            DateFormat('yyyy-MM-dd').format(_toDate!);
                        _calendarController.startDate.value = startDate;
                        _calendarController.endDate.value = endDate;
                        _calendarController.reason.value =
                            _reasonController.text;

                        print(
                            "${_calendarController.startDate.value}, ${_calendarController.endDate.value}, ${_calendarController.reason.value}");
                        await _calendarController.requestTimeOff();
                        // Get.back();
                      }
                      // Get.back();
                    },
                    buttonTitle: 'Proceed',
                    textStyleColor: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    colour: context.colorScheme.tertiary,
                    height: 50,
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
