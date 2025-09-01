import 'package:flutter/material.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/models/all_items_model.dart';

class SearchableDropdownField<T> extends StatefulWidget {
  final String title;
  final String hintText;
  final List<T> items;
  final String Function(T) displayText;
  final String Function(T) getValue;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final T? selectedItem;
  final String searchHintText;

  const SearchableDropdownField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.items,
    required this.displayText,
    required this.getValue,
    this.onChanged,
    this.validator,
    this.selectedItem,
    this.searchHintText = "Search",
  }) : super(key: key);

  @override
  State<SearchableDropdownField<T>> createState() =>
      _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T>
    extends State<SearchableDropdownField<T>> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  T? _selectedItem;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedItem = widget.selectedItem;
    _updateControllerText();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _removeOverlay(fromDispose: true); // Pass flag to indicate disposal
    super.dispose();
  }

  void _updateControllerText() {
    _controller.text =
        _selectedItem != null ? widget.displayText(_selectedItem!) : '';
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _searchController.clear();
    _filteredItems = widget.items;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        _isDropdownOpen = true;
      });
    }
  }

  void _removeOverlay({bool fromDispose = false}) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // Only call setState if not disposing and widget is still mounted
    if (!fromDispose && mounted) {
      setState(() {
        _isDropdownOpen = false;
      });
    } else {
      // Direct assignment during disposal - no setState needed
      _isDropdownOpen = false;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    double screenHeight = MediaQuery.of(context).size.height;
    double spaceBelow = screenHeight - position.dy - size.height;
    double spaceAbove = position.dy;

    bool showAbove = spaceBelow < 200 && spaceAbove > spaceBelow;
    double maxHeight = showAbove ? spaceAbove - 20 : spaceBelow - 20;
    maxHeight = maxHeight.clamp(150.0, 240.0);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: showAbove
              ? Offset(0.0, -maxHeight - 5)
              : Offset(0.0, size.height + 5),
          child: Material(
            elevation: 3.0,
            borderRadius:
                BorderRadius.circular(6), // 🔹 Reduced dropdown radius
            child: Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search field
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: // 🔹 Smaller search text
                          context.textTheme.labelMedium
                              ?.copyWith(color: const Color(0xff000000)),
                      decoration: InputDecoration(
                        hintText: widget.searchHintText,
                        hintStyle: context.textTheme.bodyMedium,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, // keeps prefixIcon aligned
                          vertical: 12, // adjusts vertical centering
                        ),
                        isDense: true,
                        border: InputBorder.none, // 🚀 no border
                        enabledBorder: InputBorder.none, // 🚀 no border
                        focusedBorder: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xffF5F5F5),
                      ),
                      onChanged: _filterItems,
                    ),
                  ),
                  const Divider(height: 1),
                  // Items list
                  Flexible(
                    child: _filteredItems.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No items found',
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xffC4C2C2)),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              final isSelected = _selectedItem != null &&
                                  widget.getValue(_selectedItem!) ==
                                      widget.getValue(item);

                              return CheckboxListTile(
                                dense: true,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -2),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                side: const BorderSide(
                                  color: Color(0xffCECECE),
                                  width: 0.8,
                                ),

                                value: isSelected,
                                activeColor: const Color(
                                    0xff00AD57), // box fill when selected
                                checkColor: Colors.white,
                                onChanged: (value) {
                                  if (mounted) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedItem = item;
                                        _updateControllerText();
                                        widget.onChanged?.call(item);
                                      } else {
                                        _selectedItem = null;
                                        _controller.clear();
                                        widget.onChanged?.call(null);
                                      }
                                    });
                                  }
                                  _removeOverlay();
                                },
                                title: Text(
                                  widget.displayText(item),
                                  style: context.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xff000000)),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _filterItems(String query) {
    if (mounted) {
      setState(() {
        if (query.isEmpty) {
          _filteredItems = widget.items;
        } else {
          _filteredItems = widget.items
              .where((item) => widget
                  .displayText(item)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AbsorbPointer(
          child: TextFormField(
            controller: _controller,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xff000000)),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: context.textTheme.bodySmall
                  ?.copyWith(color: const Color(0xffC4C2C2)),
              suffixIcon: Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            enabled: false,
          ),
        ),
      ),
    );
  }
}

// class CustomMultiSelectDropdown extends StatefulWidget {
//   final List<AllItemsModel> items;
//   final List<AllItemsModel> selectedItems;
//   final Function(List<AllItemsModel>) onChanged;
//   final String hint;

//   const CustomMultiSelectDropdown({
//     Key? key,
//     required this.items,
//     required this.selectedItems,
//     required this.onChanged,
//     this.hint = 'Select items',
//   }) : super(key: key);

//   @override
//   _CustomMultiSelectDropdownState createState() =>
//       _CustomMultiSelectDropdownState();
// }

// class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
//   bool isOpen = false;
//   String searchQuery = '';
//   late TextEditingController searchController;
//   late FocusNode searchFocusNode;
//   OverlayEntry? overlayEntry;
//   final LayerLink layerLink = LayerLink();
//   final GlobalKey dropdownKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     searchFocusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     searchFocusNode.dispose();
//     removeOverlay();
//     super.dispose();
//   }

//   void toggleDropdown() {
//     if (isOpen) {
//       removeOverlay();
//     } else {
//       createOverlay();
//     }
//   }

//   void createOverlay() {
//     overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         width: getDropdownWidth(),
//         child: CompositedTransformFollower(
//           link: layerLink,
//           showWhenUnlinked: false,
//           offset: Offset(0, 60),
//           child: Material(
//             elevation: 8,
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               constraints: BoxConstraints(maxHeight: 320, maxWidth: 600),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade400, width: 0.5),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Search field with custom styling
//                   Container(
//                     margin: EdgeInsets.all(8),
//                     child: TextField(
//                       controller: searchController,
//                       focusNode: searchFocusNode,
//                       decoration: InputDecoration(
//                         isDense: true,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 0,
//                           vertical: 12,
//                         ),
//                         filled: true,
//                         fillColor: const Color(0xffF5F5F5),
//                         hintText: "Search",
//                         hintStyle: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xffC4C2C2),
//                         ),
//                         prefixIcon: Container(
//                           padding: const EdgeInsets.all(12),
//                           child: Icon(
//                             Icons.search,
//                             size: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         border: InputBorder.none,
//                         enabledBorder: InputBorder.none,
//                         focusedBorder: InputBorder.none,
//                       ),
//                       style: TextStyle(fontSize: 14),
//                       onChanged: (value) {
//                         setState(() {
//                           searchQuery = value;
//                         });
//                       },
//                     ),
//                   ),
//                   // Items list
//                   Flexible(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       padding: EdgeInsets.zero,
//                       itemCount: getFilteredItems().length,
//                       itemBuilder: (context, index) {
//                         final item = getFilteredItems()[index];
//                         final isSelected = widget.selectedItems.contains(item);

//                         return InkWell(
//                           onTap: () => toggleSelection(item),
//                           child: Container(
//                             height: 50,
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             child: ListTile(
//                               contentPadding: EdgeInsets.zero,
//                               leading: Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? const Color(0xff00AD57)
//                                       : Colors.transparent,
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? const Color(0xff00AD57)
//                                         : const Color(0xffCECECE),
//                                     width: 0.8,
//                                   ),
//                                 ),
//                                 child: isSelected
//                                     ? const Icon(
//                                         Icons.check,
//                                         color: Colors.white,
//                                         size: 14,
//                                       )
//                                     : null,
//                               ),
//                               title: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     item.name.toString(),
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: const Color(0xff535353),
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                   ),
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: "Ref No: ",
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text: item.referenceNumber,
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                   ),
//                                 ],
//                               ),
//                               trailing: SizedBox(
//                                 width: 150,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       item.group?.name ?? '',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     RichText(
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       text: TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: "Manufacturer: ",
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           TextSpan(
//                                             text: item.inventoryManufacturer
//                                                     ?.name ??
//                                                 '',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               horizontalTitleGap: 0,
//                               dense: true,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(overlayEntry!);
//     setState(() {
//       isOpen = true;
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       searchFocusNode.requestFocus();
//     });
//   }

//   void removeOverlay() {
//     overlayEntry?.remove();
//     overlayEntry = null;
//     setState(() {
//       isOpen = false;
//       searchQuery = '';
//       searchController.clear();
//     });
//   }

//   void toggleSelection(AllItemsModel item) {
//     List<AllItemsModel> newSelection = List.from(widget.selectedItems);
//     if (newSelection.contains(item)) {
//       newSelection.remove(item);
//     } else {
//       newSelection.add(item);
//     }
//     widget.onChanged(newSelection);
//   }

//   List<AllItemsModel> getFilteredItems() {
//     if (searchQuery.isEmpty) {
//       return widget.items;
//     }
//     return widget.items.where((item) {
//       return item.name
//               .toString()
//               .toLowerCase()
//               .contains(searchQuery.toLowerCase()) ||
//           item.referenceNumber
//               .toString()
//               .toLowerCase()
//               .contains(searchQuery.toLowerCase()) ||
//           (item.group?.name
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchQuery.toLowerCase()) ??
//               false) ||
//           (item.inventoryManufacturer?.name
//                   .toString()
//                   .toLowerCase()
//                   .contains(searchQuery.toLowerCase()) ??
//               false);
//     }).toList();
//   }

//   double getDropdownWidth() {
//     final RenderBox? renderBox =
//         dropdownKey.currentContext?.findRenderObject() as RenderBox?;
//     return renderBox?.size.width ?? 200;
//   }

//   String getDisplayText() {
//     if (widget.selectedItems.isEmpty) {
//       return widget.hint;
//     } else if (widget.selectedItems.length == 1) {
//       return widget.selectedItems.first.name.toString();
//     } else {
//       return '${widget.selectedItems.length} items selected';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: layerLink,
//       child: GestureDetector(
//         key: dropdownKey,
//         onTap: toggleDropdown,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey.shade400, width: 0.5),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   getDisplayText(),
//                   style: TextStyle(
//                     color: widget.selectedItems.isEmpty
//                         ? const Color(0xffC4C2C2)
//                         : Colors.black87,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               const Icon(Icons.arrow_drop_down),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<AllItemsModel> items;
  final List<AllItemsModel> selectedItems;
  final ValueChanged<List<AllItemsModel>> onChanged;
  final String hint;

  const CustomMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.hint = "Select items",
  }) : super(key: key);

  @override
  _CustomMultiSelectDropdownState createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  List<AllItemsModel> _tempSelected = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedItems);
  }

  void _openMultiSelectDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            var filtered = widget.items
                .where((item) => item.name
                    .toString()
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                .toList();

            return AlertDialog(
              title: Text(widget.hint),
              content: SizedBox(
                height: 400, // 👈 gives bounded height
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (_) => setStateDialog(() {}),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isSelected = _tempSelected.contains(item);

                          return CheckboxListTile(
                            title: Text(item.name.toString()),
                            subtitle: Text("Ref: ${item.referenceNumber}"),
                            value: isSelected,
                            onChanged: (bool? selected) {
                              setStateDialog(() {
                                if (selected == true) {
                                  _tempSelected.add(item);
                                } else {
                                  _tempSelected.remove(item);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onChanged(_tempSelected);
                    Navigator.pop(ctx);
                  },
                  child: Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );

    // ✅ Safe setState
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (widget.selectedItems.isEmpty) {
      displayText = widget.hint;
    } else if (widget.selectedItems.length == 1) {
      displayText = widget.selectedItems.first.name.toString();
    } else {
      displayText = "${widget.selectedItems.length} items selected";
    }

    return InkWell(
      onTap: _openMultiSelectDialog,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(displayText, style: TextStyle(color: Colors.black87)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
