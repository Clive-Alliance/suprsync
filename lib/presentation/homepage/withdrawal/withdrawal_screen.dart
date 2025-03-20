import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart'
    hide SearchableDropdown;
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:suprsync/presentation/controllers/items_controller.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_controller/withdrawal_controller.dart';

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
  // ExampleNumber? selectedNumber;
  final List<DropdownMenuItem> items = [];
  String selectedLocation = '';
  String selectedItem = '';
  final WithdrawalController _withdrawalController = Get.find();
  final ItemsController _itemsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        // color: Colors.black,
        margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
        height: size.height * 0.88,
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
                searchIconWidget:
                    Image.asset('assets/icons/element-4.png', height: 18),
                backgroundDecoration: (child) => Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffdedede))),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: child,
                  ),
                ),
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: Color(0xff848484)),
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
                  print(location.address);
                  return SearchableDropdownMenuItem(
                      value: i,
                      label: location.name.toString(),
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter stateSetter) {
                        return CheckboxListTile(
                          dense: false,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -2),
                          contentPadding: EdgeInsets.zero,
                          value: isVisible,
                          onChanged: (value) {
                            stateSetter(() {
                              // reverse the value
                              print(
                                  'not sure about value${_withdrawalController.location.value}');
                              isVisible = !isVisible;
                              _withdrawalController.location.value =
                                  location.id.toString();
                              print(
                                  'not sure about value 2 ${_withdrawalController.location.value}');
                            });
                          },
                          title: Text(location.name.toString(),
                              style: context.textTheme.bodyMedium
                                  ?.copyWith(color: const Color(0xff535353))),
                          controlAffinity: ListTileControlAffinity
                              .leading, // Moves the checkbox to the left
                        );
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
              searchIconWidget:
                  Image.asset('assets/icons/element-4.png', height: 18),
              backgroundDecoration: (child) => Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xffdedede))),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: child,
                ),
              ),
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: Color(0xff848484)),
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
                  print(allItems.name.toString());
                  return SearchableDropdownMenuItem(
                    value: i,
                    label: allItems.name.toString(),
                    child: StatefulBuilder(builder: (context, setState) {
                      return CheckboxListTile(
                        dense: false,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -2),
                        contentPadding: EdgeInsets.zero,
                        value: selectedItems.contains(i), // Check if selected
                        onChanged: (bool? checked) {
                          // _withdrawalController.quantity.value =allItems.id.toString();
                          // _withdrawalController.measurementUnit.value =allItems.id.toString();

                          setState(() {
                            _withdrawalController.inventoryItemId.value =
                                allItems.id.toString();
                            print(
                                'let\'s see here too ${_withdrawalController.inventoryItemId.value = allItems.id.toString()}');
                            if (checked == true) {
                              selectedItems.add(i);
                            } else {
                              selectedItems.remove(i);
                            }
                          });
                        },
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Ref No: ",
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: Colors.black),
                              ),
                              TextSpan(
                                text: allItems.referenceNumber.toString(),
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        secondary: SizedBox(
                          width: 150,
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .end, // Align text to the left
                            children: [
                              SizedBox(
                                width:
                                    100, // Ensure text does not exceed this width
                                child: Text(
                                  allItems.group!.name.toString(),
                                  maxLines: 1, // Prevents overflow
                                  overflow: TextOverflow.ellipsis, // Show "..."
                                  style: context.textTheme.bodyMedium,
                                ),
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
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black),
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
                        ),

                        title: Text(allItems.name.toString(),
                            style: context.textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xff535353))),
                        controlAffinity: ListTileControlAffinity
                            .leading, // Moves the checkbox to the left
                      );
                    }),
                  );
                },
              ),

              // items: List.generate(
              //     10,
              //     (i) => SearchableDropdownMenuItem(
              //         value: i,
              //         label: 'item $i',
              //         child:
              //         StatefulBuilder(builder: (context, setState) {
              //           return CheckboxListTile(
              //             dense: false,
              //             visualDensity:
              //                 const VisualDensity(horizontal: -4, vertical: -2),
              //             contentPadding: EdgeInsets.zero,
              //             value: selectedItems.contains(i), // Check if selected
              //             onChanged: (bool? checked) {
              //               setState(() {
              //                 if (checked == true) {
              //                   selectedItems.add(i);
              //                 } else {
              //                   selectedItems.remove(i);
              //                 }
              //               });
              //             },
              //             subtitle: RichText(
              //               text: TextSpan(
              //                 children: [
              //                   TextSpan(
              //                     text: "Part 1 text ",
              //                     style: context.textTheme.bodySmall
              //                         ?.copyWith(color: Colors.black),
              //                   ),
              //                   TextSpan(
              //                     text: "Part 2 text",
              //                     style: context.textTheme.bodySmall
              //                         ?.copyWith(color: Colors.red),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             secondary: const Column(
              //               children: [Text('Text 1'), Text('Text 2')],
              //             ),

              //             title: Text('item $i',
              //                 style: context.textTheme.bodyMedium
              //                     ?.copyWith(color: const Color(0xff535353))),
              //             controlAffinity: ListTileControlAffinity
              //                 .leading, // Moves the checkbox to the left
              //           );
              //         }))),
              validator: (val) {
                if (val == null) return 'Can\'t be empty';
                return null;
              },
              onSaved: (val) {
                debugPrint('On save: $val');
              },
            ),
            const Expanded(
              child: SizedBox(),
            ),
            RectangularButton(
              onPress: () {
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
                        await _withdrawalController.withdrawItem();
                        Get.back();
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
}
