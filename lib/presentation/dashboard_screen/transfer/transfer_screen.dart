import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/utils/show_message.dart';
import 'package:suprsync/models/location_model.dart' as models;
import 'package:suprsync/presentation/controllers/transfer_controllers.dart';
import 'package:suprsync/presentation/dashboard_screen/transfer/transferred_items_sheet.dart';
import 'package:suprsync/presentation/dashboard_screen/widgets/dropdown_picker.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_controller/withdrawal_controller.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final WithdrawalController _withdrawalController = Get.find();
  final TransferController _transferController = Get.find();
  models.LocationModel? selectedLocation; // instead of String?

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                    _transferController.fromLocation.value = null;
                    _transferController.toLocation.value = null;
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
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text(
                    'From',
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: const Color(0xff000000)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return SearchableDropdownField<models.LocationModel>(
                      title: '',
                      hintText: 'Select location',
                      items: _withdrawalController.locationsModel,
                      displayText: (location) => location.name ?? '',
                      getValue: (location) => location.id?.toString() ?? '',
                      selectedItem: _transferController.fromLocation.value,
                      onChanged: (location) {
                        _transferController.fromLocation.value = location;

                        if (location != null) {
                          _transferController.from.value =
                              location.id.toString();
                          print('Selected location: ${location.name}');
                        }
                      },
                      validator: (val) =>
                          val == null ? 'Can\'t be empty' : null,
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
                    return SearchableDropdownField<models.LocationModel>(
                      title: '',
                      hintText: 'Select location',
                      items: _withdrawalController.locationsModel,
                      displayText: (location) => location.name ?? '',
                      getValue: (location) => location.id?.toString() ?? '',
                      selectedItem: _transferController.toLocation.value,
                      onChanged: (location) {
                        _transferController.toLocation.value = location;

                        if (location != null) {
                          _transferController.to.value = location.id.toString();
                          print('Selected location: ${location.name}');
                        }
                      },
                      validator: (val) =>
                          val == null ? 'Can\'t be empty' : null,
                    );
                  }),
                ]))),
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
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: context.colorScheme.secondary,
        context: context,
        builder: (BuildContext context) {
          return const TransferredItemsSheet();
        });
  }
}

class CustomSearchableDropdown extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelected;

  const CustomSearchableDropdown({
    Key? key,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<CustomSearchableDropdown> createState() =>
      _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<String> _filteredItems = [];
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      } else {
        _removeDropdown();
      }
    });
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: Material(
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                String item = _filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItem = item;
                      _controller.text = item;
                    });
                    widget.onItemSelected(item);
                    _removeDropdown();
                  },
                  child: ListTile(
                    title: Text(item),
                    trailing: _selectedItem == item
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    _showDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _filterItems,
          decoration: const InputDecoration(
            hintText: "Search...",
            suffixIcon: Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
