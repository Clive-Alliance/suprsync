import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/show_message.dart';
import 'package:suprsync/presentation/controllers/transfer_controllers.dart';
import 'package:suprsync/presentation/homepage/transfer/transferred_items_sheet.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_controller/withdrawal_controller.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final WithdrawalController _withdrawalController = Get.find();
  final TransferController _transferController = Get.find();
  String selectedLocation = '';

  bool isVisible = false;
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
            Text(
              'Transferred Items List',
              style: context.textTheme.headlineSmall?.copyWith(),
            ),
            const SizedBox(height: 4),
            Text('List of transferred items from one location to another',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff616161))),
            const SizedBox(
              height: 28,
            ),
            Text(
              'From',
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
                                  'not sure about value${_transferController.from.value}');
                              isVisible = !isVisible;
                              _transferController.from.value =
                                  location.id.toString();
                              print(
                                  'not sure about value 2 ${_transferController.from.value}');
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
              'To',
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
                                  'not sure about value 3 ${_transferController.to.value}');
                              isVisible = !isVisible;
                              _transferController.to.value =
                                  location.id.toString();
                              print(
                                  'not sure about value 4 ${_transferController.to.value}');
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
            const Expanded(
              child: SizedBox(),
            ),
            RectangularButton(
              onPress: () {
                if (_transferController.from.value.isEmpty) {
                  showMessage('Please select a location', context);
                } else {}
                showTransferredItemsSheet(context);
              },
              buttonTitle: 'Fetch list',
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

  void showTransferredItemsSheet(BuildContext context) {
    // final ValueCallback onValueSelected;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    // AuthController _authController = AuthController();
    bool isVisible = false;

    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: context.colorScheme.secondary,
        context: context,
        builder: (BuildContext context) {
          return TransferredItemsSheet(
              // emailController: _emailController,
              // // isVisible: isVisible,
              // passwordController: _passwordController,
              // authController: _authController
              );
        });
  }
}
