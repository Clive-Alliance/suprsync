import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/show_message.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/all_items_model.dart';
import 'package:suprsync/models/location_model.dart' as loc;
import 'package:suprsync/presentation/controllers/items_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/widgets/multiple_dropdown_widget.dart.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_controller/withdrawal_controller.dart';

import '../widgets/dropdown_picker.dart';

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
  List<int> selectedItemsMultiDialog = [];

  final List<DropdownMenuItem<AllItemsModel>> _customDroplist = [];
  List<int> selectedItemsMultiCustomDisplayDialog = [];

  @override
  void initState() {
    if (_itemsController.allItemsModel.isNotEmpty) {
      _itemsController.allItemsModel.forEach((element) {
        _customDroplist.add(DropdownMenuItem<AllItemsModel>(
          value: element,
          child: Text(
            element.name.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _withdrawalController.selectedLocation.value = null;
                    _withdrawalController.selectedItems.clear();
                    _withdrawalController.selectedWithdrawals.clear();
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
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text(
                    'Location',
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: const Color(0xff000000)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return SearchableDropdownField<loc.LocationModel>(
                      title: '',
                      hintText: 'Select location',
                      items: _withdrawalController.locationsModel,
                      displayText: (location) => location.name ?? '',
                      getValue: (location) => location.id?.toString() ?? '',
                      selectedItem:
                          _withdrawalController.selectedLocation.value,
                      onChanged: (location) {
                        _withdrawalController.selectedLocation.value = location;

                        // if (location != null) {
                        //   _withdrawalController.location.value =
                        //       location.id.toString();
                        //   print(_withdrawalController.location.value);
                        // }
                      },
                      validator: (val) =>
                          val == null ? 'Can\'t be empty' : null,
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
                  MultipleDropdown.multiple(
                    key: ValueKey(
                        'item_selector_${_withdrawalController.selectedItems.length}'),
                    items: _customDroplist,
                    selectedItems: selectedItemsMultiCustomDisplayDialog,
                    iconSize: 0,
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: const Color(0xffC4C2C2)),
                    hint: "Select item",
                    onChanged: (value) {
                      // _withdrawalController.selectedItems.value = value;
                    },

                    icon: const Icon(Icons.arrow_drop_down),
                    fieldDecoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade400, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    menuBackgroundColor: Colors.white,
                    displayClearIcon: false,
                    // doneButton: null,
                    closeButton: null,
                    dropDownDialogPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    searchInputDecoration: InputDecoration(
                      isDense: true, // makes the height smaller
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0, // keeps prefixIcon aligned
                        vertical: 12, // adjusts vertical centering
                      ), // 👈 removes all padding

                      filled: true,
                      fillColor: const Color(0xffF5F5F5), // background color
                      hintText: "Search", // 👈 customize hint text here
                      hintStyle: context.textTheme.bodyMedium,

                      //         ?.copyWith(color: Color(0xffC4C2C2)),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(
                            12), // Add padding around the icon
                        child: Image.asset(
                          'assets/icons/element-4.png',
                          height: 14,
                          width: 14, // Also specify width
                          fit: BoxFit.contain, // Ensures proper scaling
                        ),
                      ),
                      border: InputBorder.none, // 🚀 no border
                      enabledBorder: InputBorder.none, // 🚀 no border
                      focusedBorder: InputBorder.none,
                    ),
                    searchFn: (String keyword,
                        List<DropdownMenuItem<AllItemsModel>> items) {
                      List<int> _ret = [];
                      if (items.length > 0 && keyword.isNotEmpty) {
                        int i = 0;
                        items.forEach((item) {
                          if (!_ret.contains(i) &&
                              (item.value!.name
                                  .toString()
                                  .toLowerCase()
                                  .contains(keyword.toLowerCase()))) {
                            _ret.add(i);
                          }
                          i++;
                        });
                      }
                      if (keyword.isEmpty) {
                        _ret = Iterable<int>.generate(items.length).toList();
                      }
                      return (_ret);
                    },
                    isExpanded: true,

                    doneButton: null,
                    autofocus: false,

                    // underline: SizedBox(),
                    dialogBox: false,
                    menuConstraints:
                        const BoxConstraints(maxHeight: 320, maxWidth: 600),
                    // _withdrawalController.updateSelectedItems(value);
                    selectedValueWidgetFn: (AllItemsModel item) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _withdrawalController.toggleItemSelection(item);
                      });
                      return const Text('');
                    },

                    // selectedAggregateWidgetFn: (List<Widget> list) {
                    //   return Wrap(children: list);
                    // },
                    displayItem: (DropdownMenuItem<AllItemsModel> item,
                        bool selected, Function updateParent) {
                      AllItemsModel value = item.value as AllItemsModel;

                      return SizedBox(
                        height: 50,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.zero, // ✅ removes extra bottom space
                          // visualDensity: const VisualDensity(vertical: -1),

                          leading: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xff00AD57)
                                  : Colors.transparent,
                              border: Border.all(
                                color: selected
                                    ? const Color(0xff00AD57)
                                    : const Color(0xffCECECE),
                                width: 0.8,
                              ),
                              // borderRadius: BorderRadius.circular(4),
                            ),
                            child: selected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),

                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.name.toString(),
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xff535353)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Ref No: ",
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: value.referenceNumber.toString(),
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),

                          trailing: SizedBox(
                            width: 150,
                            // height: 100,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  value.group!.name.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodyMedium,
                                ),
                                // const SizedBox(height: 4),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // limit to one line with ...
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Manufacturer: ",
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: value.inventoryManufacturer?.name
                                            .toString(),
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: const Color(0xff000000),
                                          overflow: TextOverflow
                                              .ellipsis, // Ellipsis inside TextSpan
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          horizontalTitleGap: 0,
                          dense: true,
                          // visualDensity: VisualDensity.compact,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Obx(() {
                    return Visibility(
                      visible: _withdrawalController.selectedItems.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Item',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // ListView to display all selected items
                          SizedBox(
                            height: 300, // Set appropriate height
                            child: Obx(() {
                              final selectedItems =
                                  _withdrawalController.selectedItems;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: selectedItems.length,
                                itemBuilder: (context, index) {
                                  final selectedItem = selectedItems[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 13,
                                        bottom: 13),
                                    color: const Color(0xffF9F9F9),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Left side - Item details

                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    selectedItem.name!,
                                                    style: context
                                                        .textTheme.labelLarge
                                                        ?.copyWith(
                                                            color: const Color(
                                                                0xff000000)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "Ref No: ",
                                                          style: context
                                                              .textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                                  color: const Color(
                                                                      0xff535353)),
                                                        ),
                                                        TextSpan(
                                                          text: selectedItem
                                                              .referenceNumber
                                                              .toString(),
                                                          style: context
                                                              .textTheme
                                                              .labelMedium
                                                              ?.copyWith(
                                                                  color: const Color(
                                                                      0xff000000)),
                                                        ),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //  SizedBox(

                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    selectedItem.group!.name
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: context
                                                        .textTheme.labelLarge
                                                        ?.copyWith(
                                                            color: const Color(
                                                                0xff282828)),
                                                  ),
                                                  // const SizedBox(height: 4),
                                                  RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines:
                                                        1, // limit to one line with ...
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Manufacturer: ",
                                                          style: context
                                                              .textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                                  color: const Color(
                                                                      0xff282828)),
                                                        ),
                                                        TextSpan(
                                                          text: selectedItem
                                                              .inventoryManufacturer
                                                              ?.name
                                                              .toString(),
                                                          style: context
                                                              .textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                            color: const Color(
                                                                0xff000000),
                                                            overflow: TextOverflow
                                                                .ellipsis, // Ellipsis inside TextSpan
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),

                                        Text(
                                          'Measurement Unit',
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xff000000)),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF9F9F9),
                                            border: Border.all(
                                                color: const Color(0xffDEDEDE),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Obx(() {
                                            final units = _withdrawalController
                                                .measurementUnitModel;
                                            final currentWithdrawal =
                                                _withdrawalController
                                                    .getWithdrawalForItem(
                                                        selectedItem.id
                                                            .toString());

                                            return DropdownButton<String>(
                                              value: currentWithdrawal
                                                          ?.measurementUnitName
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? currentWithdrawal!
                                                      .measurementUnitName
                                                  : null,

                                              hint: Text("Select Unit",
                                                  style: context
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                          color: const Color(
                                                              0xffC4C2C2))),
                                              // icon: ,\
                                              dropdownColor: Colors.white,
                                              padding: EdgeInsets.zero,
                                              style: context
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                      color: const Color(
                                                          0xff000000)),
                                              isExpanded: true,
                                              underline: const SizedBox(),

                                              items: units.map((unit) {
                                                return DropdownMenuItem(
                                                  value: unit.name,
                                                  child: Text(
                                                      unit.name.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                if (newValue != null) {
                                                  final selectedUnit =
                                                      units.firstWhere((u) =>
                                                          u.name == newValue);
                                                  _withdrawalController
                                                      .updateMeasurementUnit(
                                                    selectedItem.id.toString(),
                                                    selectedUnit.id
                                                        .toString(), // backend id
                                                    selectedUnit.name ??
                                                        '', // display name
                                                  );
                                                  // _withdrawalController
                                                  //     .updateMeasurementUnit(
                                                  //         selectedItem.id
                                                  //             .toString(),
                                                  //         newValue);
                                                }
                                              },
                                            );
                                          }),
                                        ),

                                        const SizedBox(height: 20),

                                        // Quantity section
                                        Text('Quantity',
                                            style: context.textTheme.labelSmall
                                                ?.copyWith(
                                                    color: const Color(
                                                        0xff000000))),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 38,
                                          width: 110,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xffDEDEDE),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: const Color(0xffF9F9F9),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Color(0xff606061),
                                                  size: 15,
                                                ),
                                                onPressed: () {
                                                  final currentQuantity =
                                                      _withdrawalController
                                                              .getWithdrawalForItem(
                                                                  selectedItem
                                                                      .id
                                                                      .toString())
                                                              ?.quantity ??
                                                          1;
                                                  _withdrawalController
                                                      .updateQuantity(
                                                          selectedItem.id
                                                              .toString(),
                                                          currentQuantity + 1);
                                                },
                                              ),
                                              Obx(() {
                                                final currentWithdrawal =
                                                    _withdrawalController
                                                        .getWithdrawalForItem(
                                                            selectedItem.id
                                                                .toString());
                                                final quantity =
                                                    currentWithdrawal
                                                            ?.quantity ??
                                                        1;

                                                return Text(
                                                  quantity.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xffC5C2C2)),
                                                );
                                              }),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.remove,
                                                  color: Color(0xff606061),
                                                  size: 15,
                                                ),
                                                onPressed: () {
                                                  final currentQuantity =
                                                      _withdrawalController
                                                              .getWithdrawalForItem(
                                                                  selectedItem
                                                                      .id
                                                                      .toString())
                                                              ?.quantity ??
                                                          1;
                                                  if (currentQuantity > 1) {
                                                    _withdrawalController
                                                        .updateQuantity(
                                                            selectedItem.id
                                                                .toString(),
                                                            currentQuantity -
                                                                1);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }),
                ]))),

            // const Expanded(
            //   child: SizedBox(),
            // ),
            RectangularButton(
              onPress: () {
                if (_withdrawalController.selectedLocation.value == null) {
                  showMessage('Please select a location', context);
                } else {
                  showWithdrawDialog();
                }
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
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w600),
                      colour: const Color(0xff00AD57),
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
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              RectangularButton(
                onPress: () async {
                  Get.back();
                },
                buttonTitle: 'Ok',
                textStyleColor: context.textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600),
                colour: const Color(0xff00AD57),
                height: 50,
              ),
            ],
          ),
        )));
  }
}
