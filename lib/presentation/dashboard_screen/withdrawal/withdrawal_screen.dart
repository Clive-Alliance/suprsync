import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart'
    hide SearchableDropdown;
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:suprsync/core/utils/show_message.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/all_items_model.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';
import 'package:suprsync/presentation/controllers/items_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_controller/withdrawal_controller.dart';

class WithdrawalSheetSheet extends StatefulWidget {
  const WithdrawalSheetSheet({
    super.key,
  });

  @override
  State<WithdrawalSheetSheet> createState() => _WithdrawalSheetSheetState();
}

class _WithdrawalSheetSheetState extends State<WithdrawalSheetSheet> {
  bool isVisible = false;
  final Set<int> selectedItems = {}; // Track selected items
  String? selectedValue;
  String preselectedValue = "dolor sit";
  final List<DropdownMenuItem> items = [];
  String selectedLocation = '';
  final WithdrawalController _withdrawalController = Get.find();
  final ItemsController _itemsController = Get.find();
  AllItemsModel? selectedItem;
  final RxInt quantity = 0.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          // color: Colors.black,
          margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
          // height: size.height * 0.88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      'assets/icons/arrow-left.png',
                      width: 16,
                      // height: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Back',
                    style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0xff727272),
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                'Withdraw Items',
                style: context.textTheme.headlineSmall?.copyWith(),
              ),
              const SizedBox(height: 9),
              Text('Withdraw items seamlessly',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: const Color(0xff616161))),
              const SizedBox(
                height: 28,
              ),
              Text(
                'Location',
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xff000000)),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                if (_withdrawalController.isLoading.value) {}
                return SearchableDropdownFormField<int>(
                  // margin,
                  // searchIconWidget:
                  //     Image.asset('assets/icons/element-4.png', height: 18),
                  backgroundDecoration: (child) => Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffdedede))),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: child,
                    ),
                  ),
                  // style: context.textTheme.bodyMedium
                  //     ?.copyWith(color: Color(0xff848484)),
                  hintText: Text(
                    'Select location',
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: Color(0xffC4C2C2)),
                  ),
                  margin: const EdgeInsets.all(0),
                  dialogOffset: 05,

                  items: List.generate(
                      _withdrawalController.locationsModel.length, (i) {
                    var location = _withdrawalController.locationsModel[i];

                    return SearchableDropdownMenuItem(
                        value: i,
                        label: location.name.toString(),
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter stateSetter) {
                          return GestureDetector(
                            behavior: HitTestBehavior
                                .translucent, // Ensures tap is detected even on empty areas
                            onTap: () {
                              stateSetter(() {
                                print(
                                    'not sure about value${_withdrawalController.location.value}');
                                isVisible = !isVisible;
                                _withdrawalController.location.value =
                                    location.id.toString();
                              });
                            },
                            child: Container(
                              height: 28,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    // margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isVisible
                                            ? Colors.green
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                      color: isVisible
                                          ? Colors.green
                                          : Colors.transparent,
                                    ),
                                    child: isVisible
                                        ? const Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(location.name.toString(),
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: const Color(0xff535353))),
                                ],
                              ),
                            ),
                          );

                          // CheckboxListTile(
                          //   dense: false,
                          //   visualDensity: const VisualDensity(
                          //       horizontal: -4, vertical: -2),
                          //   contentPadding: EdgeInsets.zero,
                          //   value: isVisible,
                          //   onChanged: (value) {
                          //     stateSetter(() {
                          //       // reverse the value
                          //       print(
                          //           'not sure about value${_withdrawalController.location.value}');
                          //       isVisible = !isVisible;
                          //       _withdrawalController.location.value =
                          //           location.id.toString();
                          //       print(
                          //           'not sure about value 2 ${_withdrawalController.location.value}');
                          //     });
                          //   },
                          //   title:
                          //   controlAffinity: ListTileControlAffinity
                          //       .leading, // Moves the checkbox to the left
                          // );
                        }));
                  }),
                  validator: (val) {
                    if (val == null) return 'Can\'t be empty';
                    return null;
                  },
                  onSaved: (val) {
                    debugPrint('On save: $val');
                  },
                );
              }),
              const SizedBox(
                height: 18,
              ),
              Text(
                'Item',
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xff000000)),
              ),
              const SizedBox(
                height: 10,
              ),
              SearchableDropdownFormField<int>(
                initialValue:
                    selectedItems.isNotEmpty ? selectedItems.first : null,

                // margin,
                // searchIconWidget:
                //     Image.asset('assets/icons/element-4.png', height: 18),
                backgroundDecoration: (child) => Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffdedede))),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: child,
                  ),
                ),
                // style: context.textTheme.bodyMedium
                //     ?.copyWith(color: Color(0xff848484)),
                hintText: Text(
                  'Select item',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: Color(0xffC4C2C2)),
                ),
                margin: const EdgeInsets.all(0),
                dialogOffset: 05,
                items: List.generate(
                  _itemsController.allItemsModel.length,
                  (i) {
                    var allItems = _itemsController.allItemsModel[i];
                    return SearchableDropdownMenuItem(
                        value: i,
                        label: allItems.name.toString(),
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter stateSetter) {
                          return GestureDetector(
                            onTap: () {
                              stateSetter(() {
                                isVisible = !isVisible;
                                bool newValue = !selectedItems.contains(i);
                                if (newValue) {
                                  selectedItems.add(i);
                                } else {
                                  selectedItems.remove(i);
                                }

                                // Update controller values
                                _withdrawalController.inventoryItemId.value =
                                    allItems.id.toString();
                                _withdrawalController.selectedValue.value =
                                    allItems;
                                print(
                                    'let\'s see here too ${_withdrawalController.inventoryItemId.value}');
                              });
                            },
                            child: Container(
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    // behavior: ,
                                    onTap: () {
                                      setState(() {
                                        if (selectedItems.contains(i)) {
                                          selectedItems.remove(i);
                                        } else {
                                          selectedItems.add(i);
                                        }
                                        isVisible = !isVisible;

                                        _withdrawalController.inventoryItemId
                                            .value = allItems.id.toString();
                                        _withdrawalController
                                            .selectedValue.value = allItems;
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: isVisible
                                              ? Colors.green
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        color: isVisible
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                      child: isVisible
                                          ? const Icon(Icons.check,
                                              size: 16, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8), // Space between checkbox and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allItems.name.toString(),
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xff535353)),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Ref No: ",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: allItems.referenceNumber
                                                    .toString(),
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8), // Space between text and right-side content
                                  SizedBox(
                                    width: 150,
                                    height: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            allItems.group!.name.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textTheme.bodyMedium,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          width: 150,
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Manufacturer: ",
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: Colors.black),
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
                            ),
                          );
                        })
                        // return CheckboxListTile(
                        //   dense: false,
                        //   visualDensity:
                        //       const VisualDensity(horizontal: -4, vertical: -2),
                        //   contentPadding: EdgeInsets.zero,
                        //   value: selectedItems.contains(i), // Check if selected
                        //   onChanged: (bool? checked) {
                        //     setState(() {
                        //       isVisible = !isVisible;
                        //       _withdrawalController.inventoryItemId.value =
                        //           allItems.id.toString();
                        //       _withdrawalController.selectedValue.value =
                        //           allItems;

                        //       if (checked == true) {
                        //         selectedItems.add(i);
                        //       } else {
                        //         selectedItems.remove(i);
                        //       }
                        //     });
                        //   },
                        //   subtitle: RichText(
                        //     text: TextSpan(
                        //       children: [
                        //         TextSpan(
                        //           text: "Ref No: ",
                        //           style: context.textTheme.bodySmall
                        //               ?.copyWith(color: Colors.black),
                        //         ),
                        //         TextSpan(
                        //           text: allItems.referenceNumber.toString(),
                        //           style: context.textTheme.bodySmall
                        //               ?.copyWith(color: Colors.black),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   secondary: SizedBox(
                        //     width: 150,
                        //     height: 80,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment
                        //           .end, // Align text to the left
                        //       children: [
                        //         SizedBox(
                        //           width:
                        //               100, // Ensure text does not exceed this width
                        //           child: Text(
                        //             allItems.group!.name.toString(),
                        //             maxLines: 1, // Prevents overflow
                        //             overflow:
                        //                 TextOverflow.ellipsis, // Show "..."
                        //             style: context.textTheme.bodyMedium,
                        //           ),
                        //         ),
                        //         const SizedBox(height: 4), // Add spacing
                        //         SizedBox(
                        //           width: 150,
                        //           child: RichText(
                        //             overflow: TextOverflow
                        //                 .ellipsis, // Ensure RichText also respects boundaries
                        //             maxLines:
                        //                 2, // Allow up to 2 lines before ellipses
                        //             text: TextSpan(
                        //               children: [
                        //                 TextSpan(
                        //                   text: "Manufacturer: ",
                        //                   style: context.textTheme.bodySmall
                        //                       ?.copyWith(color: Colors.black),
                        //                 ),
                        //                 // TextSpan(
                        //                 //   text: allItems
                        //                 //       .inventoryManufacturer?.name
                        //                 //       .toString(),
                        //                 //   style: context.textTheme.bodySmall
                        //                 //       ?.copyWith(
                        //                 //     color: Colors.red,
                        //                 //     overflow: TextOverflow
                        //                 //         .ellipsis, // Ellipsis inside TextSpan
                        //                 //   ),
                        //                 // ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),

                        //   title: Text(allItems.name.toString(),
                        //       style: context.textTheme.bodyMedium
                        //           ?.copyWith(color: const Color(0xff535353))),
                        //   controlAffinity: ListTileControlAffinity
                        //       .leading, // Moves the checkbox to the left
                        // );

                        );
                  },
                ),

                validator: (val) {
                  if (val == null) return 'Can\'t be empty';
                  return null;
                },
                onSaved: (val) {
                  debugPrint('On save: $val');
                },
              ),
              const SizedBox(
                height: 18,
              ),
              Obx(() {
                if (_withdrawalController.selectedValue.value == null) {
                  return const SizedBox(); // Show nothing if no item is selected
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Item',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 12, right: 12, top: 13, bottom: 13),
                        color: Color(0xffF9F9F9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          _withdrawalController
                                              .selectedValue.value!.name
                                              .toString(),
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w500,
                                          )),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Ref No: ",
                                              style: context
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.black),
                                            ),
                                            TextSpan(
                                              text: _withdrawalController
                                                  .selectedValue
                                                  .value!
                                                  .referenceNumber
                                                  .toString(),
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .end, // Align text to the left
                                    children: [
                                      Text(
                                        _withdrawalController
                                            .selectedValue.value!.group!.name
                                            .toString(),
                                        maxLines: 1, // Prevents overflow
                                        overflow:
                                            TextOverflow.ellipsis, // Show "..."
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 4), // Add spacing
                                      SizedBox(
                                        width: 150,
                                        child: RichText(
                                          overflow: TextOverflow
                                              .ellipsis, // Ensure RichText also respects boundaries
                                          maxLines:
                                              2, // Allow up to 2 lines before ellipses
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Manufacturer: ",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                              // TextSpan(
                                              //   text: allItems
                                              //       .inventoryManufacturer?.name
                                              //       .toString(),
                                              //   style: context.textTheme.bodySmall
                                              //       ?.copyWith(
                                              //     color: Colors.red,
                                              //     overflow: TextOverflow
                                              //         .ellipsis, // Ellipsis inside TextSpan
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Moves the checkbox to the left
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Measureent Unit'),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity, // Full width
                              height: 50, // Fixed height
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12), // Padding inside
                              decoration: BoxDecoration(
                                color: Color(0xffF9F9F9),
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5), // Border color & thickness
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                                // Background color
                              ),
                              child: Obx(() {
                                // Extract all unit names from the list
                                final units =
                                    _withdrawalController.measurementUnitModel;

                                // Ensure selected value exists
                                if (_withdrawalController
                                        .measurementUnit.value.isNotEmpty &&
                                    !units.any((unit) =>
                                        unit.name ==
                                        _withdrawalController
                                            .measurementUnit.value)) {
                                  _withdrawalController.measurementUnit.value =
                                      "";
                                  _withdrawalController.measurementUnitId
                                      .value = ""; // Reset unit ID
                                }

                                return DropdownButton<String>(
                                  value: _withdrawalController
                                          .measurementUnit.value.isEmpty
                                      ? null
                                      : _withdrawalController
                                          .measurementUnit.value,
                                  hint: const Text(
                                      "Select Unit"), // Provide a hint for null state
                                  isExpanded:
                                      true, // Ensure full width dropdown
                                  underline:
                                      const SizedBox(), // Remove default underline
                                  items: units.map((unit) {
                                    return DropdownMenuItem(
                                      value: unit.name,
                                      child: Text(unit.name.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    _withdrawalController.measurementUnit
                                        .value = newValue.toString();

                                    // Find and update the unitId
                                    final selectedUnit = units.firstWhere(
                                        (unit) => unit.name == newValue);
                                    _withdrawalController.measurementUnitId
                                        .value = selectedUnit.id.toString();
                                  },
                                );
                              }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Quantity'),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 50,
                              width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5), // Border color & thickness
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                                color: Color(0xffF9F9F9), // Background color
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Decrease Button
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Color(0xff606061)),
                                    onPressed: () {
                                      if (quantity.value > 1) {
                                        quantity.value--;
                                      }
                                    },
                                  ),

                                  // Display Quantity
                                  Obx(() {
                                    _withdrawalController.quantity.value =
                                        int.parse(quantity.value.toString());
                                    return Text(
                                      quantity.value.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffC5C2C2)),
                                    );
                                  }),

                                  // Increase Button
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Color(0xff606061)),
                                    onPressed: () {
                                      quantity.value++;
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                );
              }),
              const Expanded(
                child: SizedBox(),
              ),
              RectangularButton(
                onPress: () {
                  if (_withdrawalController.location.value.isEmpty ||
                      _withdrawalController.inventoryItemId.value.isEmpty) {
                    print('called here');
                    showMessage('Please select a location', context);
                  } else {}
                  showWithdrawDialog();
                },
                buttonTitle: 'Withdraw',
                textStyleColor: context.textTheme.labelLarge
                    ?.copyWith(color: context.colorScheme.secondary),
                colour: context.colorScheme.tertiary,
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  showWithdrawDialog() {
    Get.dialog(Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: 349,
          height: 196,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          // size.width,
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 20, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Are you sure you want to\nwithdraw items",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TransparentRectangularButton(
                      onPress: () {
                        Get.back();
                        // Add your login logic here
                      },
                      buttonTitle: 'Cancel',
                      textStyleColor: context.textTheme.labelLarge?.copyWith(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700),
                      colour: const Color(0xff000000),
                      height: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: RectangularButton(
                      onPress: () async {
                        await _withdrawalController
                            .withdrawItem()
                            .then((value) {
                          showSuccessfulWithdrawal(value);
                          Get.back();
                        }).catchError((onError) {
                          showSnackBar(onError);
                        });
                      },
                      buttonTitle: 'Yes',
                      textStyleColor: context.textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w600),
                      colour: Color(0xff00AD57),
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  showSuccessfulWithdrawal(String value) {
    Get.dialog(Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: 349,
          height: 196,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          // size.width,
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 20, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              RectangularButton(
                onPress: () async {
                  Get.back();
                },
                buttonTitle: 'Ok',
                textStyleColor: context.textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w600),
                colour: Color(0xff00AD57),
                height: 50,
              ),
            ],
          ),
        )));
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class User {
//   final String name;
//   final int id;

//   User({required this.name, required this.id});

//   @override
//   String toString() {
//     return 'User(name: $name, id: $id)';
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _formKey = GlobalKey<FormState>();

//   final controller = MultiSelectController<User>();
//   final List<DropdownMenuItem> items = [];
//   String selectedValue = '';

//   final String loremIpsum =
//       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
//   @override
//   void initState() {
//     String wordPair = "";
//     loremIpsum
//         .toLowerCase()
//         .replaceAll(",", "")
//         .replaceAll(".", "")
//         .split(" ")
//         .forEach((word) {
//       if (wordPair.isEmpty) {
//         wordPair = word + " ";
//       } else {
//         wordPair += word;
//         if (items.indexWhere((item) {
//               return (item.value == wordPair);
//             }) ==
//             -1) {
//           items.add(DropdownMenuItem(
//             child: Text(wordPair),
//             value: wordPair,
//           ));
//         }
//         wordPair = "";
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       SearchableDropdown.single(
//                         items: [
//                           DropdownMenuItem(
//                             child: Text("one item"),
//                             value: "one item",
//                           ),
//                           DropdownMenuItem(
//                             child: Text("one item"),
//                             value: "one item",
//                           ),
//                           DropdownMenuItem(
//                             child: Text("one item"),
//                             value: "one item",
//                           ),
//                           DropdownMenuItem(
//                             child: Text("three item"),
//                             value: "three item",
//                           )
//                         ],
//                         value: selectedValue,
//                         hint: "Select one",
//                         searchHint: "Select one",
//                         onChanged: (value) {
//                           setState(() {
//                             selectedValue = value;
//                           });
//                         },
//                         doneButton: "Done",
//                         displayItem: (item, selected) {
//                           return (Row(children: [
//                             selected
//                                 ? Icon(
//                                     Icons.radio_button_checked,
//                                     color: Colors.grey,
//                                   )
//                                 : Icon(
//                                     Icons.radio_button_unchecked,
//                                     color: Colors.grey,
//                                   ),
//                             SizedBox(width: 7),
//                             Expanded(
//                               child: item,
//                             ),
//                           ]));
//                         },
//                         isExpanded: true,
//                       ),
//                       // MultiDropdown<User>(
//                       //   items: items,
//                       //   controller: controller,
//                       //   enabled: true,
//                       //   searchEnabled: true,
//                       //   chipDecoration: const ChipDecoration(
//                       //     backgroundColor: Colors.yellow,
//                       //     wrap: true,
//                       //     runSpacing: 2,
//                       //     spacing: 10,
//                       //   ),
//                       //   fieldDecoration: FieldDecoration(
//                       //     hintText: 'Countries',
//                       //     hintStyle: const TextStyle(color: Colors.black87),
//                       //     prefixIcon: const Icon(CupertinoIcons.flag),
//                       //     showClearIcon: false,
//                       //     border: OutlineInputBorder(
//                       //       borderRadius: BorderRadius.circular(12),
//                       //       borderSide: const BorderSide(color: Colors.grey),
//                       //     ),
//                       //     focusedBorder: OutlineInputBorder(
//                       //       borderRadius: BorderRadius.circular(12),
//                       //       borderSide: const BorderSide(
//                       //         color: Colors.black87,
//                       //       ),
//                       //     ),
//                       //   ),
//                       //   dropdownDecoration: const DropdownDecoration(
//                       //     marginTop: 2,
//                       //     maxHeight: 500,
//                       //     header: Padding(
//                       //       padding: EdgeInsets.all(8),
//                       //       child: Text(
//                       //         'Select countries from the list',
//                       //         textAlign: TextAlign.start,
//                       //         style: TextStyle(
//                       //           fontSize: 16,
//                       //           fontWeight: FontWeight.bold,
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ),
//                       //   dropdownItemDecoration: DropdownItemDecoration(
//                       //     selectedIcon:
//                       //         const Icon(Icons.check_box, color: Colors.green),
//                       //     disabledIcon:
//                       //         Icon(Icons.lock, color: Colors.grey.shade300),
//                       //   ),
//                       //   validator: (value) {
//                       //     if (value == null || value.isEmpty) {
//                       //       return 'Please select a country';
//                       //     }
//                       //     return null;
//                       //   },
//                       //   onSelectionChange: (selectedItems) {
//                       //     debugPrint("OnSelectionChange: $selectedItems");
//                       //   },
//                       // ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 8,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState?.validate() ?? false) {
//                                 final selectedItems = controller.selectedItems;

//                                 debugPrint(selectedItems.toString());
//                               }
//                             },
//                             child: const Text('Submit'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.selectAll();
//                             },
//                             child: const Text('Select All'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.clearAll();
//                             },
//                             child: const Text('Unselect All'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.addItems([
//                                 DropdownItem(
//                                     label: 'France',
//                                     value: User(name: 'France', id: 8)),
//                               ]);
//                             },
//                             child: const Text('Add Items'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.selectWhere((element) =>
//                                   element.value.id == 1 ||
//                                   element.value.id == 2 ||
//                                   element.value.id == 3);
//                             },
//                             child: const Text('Select Where'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.selectAtIndex(0);
//                             },
//                             child: const Text('Select At Index'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               controller.openDropdown();
//                             },
//                             child: const Text('Open/Close dropdown'),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
