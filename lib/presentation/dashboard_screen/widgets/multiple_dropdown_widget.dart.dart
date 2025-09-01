import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'dart:core';

class MultipleDropdown<T> extends FormField<T> {
  static Widget Function(Widget)? dialogBoxMenuWrapper;
  final List<DropdownMenuItem<T>>? items;
  final Function? onChanged;
  final T? value;
  final TextStyle? style;
  final dynamic searchHint;
  final dynamic hint;
  final dynamic disabledHint;
  final dynamic icon;
  final dynamic underline;
  final dynamic doneButton;
  final dynamic label;
  final dynamic closeButton;
  final bool displayClearIcon;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double iconSize;
  final bool isExpanded;
  final bool isCaseSensitiveSearch;
  final Function? searchFn;
  final Function? onClear;
  final Function? selectedValueWidgetFn;
  final TextInputType keyboardType;
  final String? Function(T?)? validator;
  final bool multipleSelection;
  final List<int> selectedItems;
  final Function? displayItem;
  final bool dialogBox;
  final BoxConstraints? menuConstraints;
  final bool readOnly;
  final Color? menuBackgroundColor;
  final bool? rightToLeft;
  final bool autofocus;

  final Function? selectedAggregateWidgetFn;

  final dynamic padding;

  final Function? setOpenDialog;

  final Widget Function(
    Widget titleBar,
    Widget searchBar,
    Widget list,
    Widget closeButton,
    BuildContext dropDownContext,
  )? buildDropDownDialog;

  /// [dropDownDialogPadding] [EdgeInsets] sets the padding between the screen
  /// and the dialog.
  final EdgeInsets? dropDownDialogPadding;

  /// [searchInputDecoration] [InputDecoration] sets the search bar decoration.
  final InputDecoration? searchInputDecoration;

  /// [itemsPerPage] [int] if set, organizes the search list per page with the
  /// given number of items displayed per page. Must give [currentPage].
  final int? itemsPerPage;

  /// [currentPage] [PointerThisPlease<int>] if [itemsPerPage] is set, holds the
  /// page number for the search items to be displayed.
  final PointerThisPlease<int>? currentPage;

  /// [customPaginationDisplay] Widget Function(Widget listWidget, int
  /// totalFilteredItemsNb, Function updateSearchPage) if [itemsPerPage] is set,
  /// customizes the display and the handling of the pagination on the search
  /// list.
  final Widget Function(Widget listWidget, int totalFilteredItemsNb,
      Function updateSearchPage)? customPaginationDisplay;

  /// [futureSearchFn] Future<int> Function(String keyword,
  /// List<DropdownMenuItem> itemsListToClearAndFill, int pageNb) used to
  /// search items from the network. Must return items (up to [itemsPerPage] if
  /// set). Must return an [int] with the total number of results (allows the
  /// handling of pagination).
  final Future<Tuple2<List<DropdownMenuItem>, int>> Function(
      String? keyword,
      String? orderBy,
      bool? orderAsc,
      List<Tuple2<String, String>>? filters,
      int? pageNb)? futureSearchFn;

  final Map<String, Map<String, dynamic>>? futureSearchOrderOptions;
  final Map<String, Map<String, Object>>? futureSearchFilterOptions;
  final List<T>? futureSelectedValues;
  final dynamic emptyListWidget;
  final Function? onTap;
  final Function? futureSearchRetryButton;
  final int? searchDelay;
  final Widget Function(Widget fieldWidget, {bool selectionIsValid})?
      fieldPresentationFn;
  final Decoration? fieldDecoration;
  final Future<void> Function(
    BuildContext context,
    Widget Function({
      String searchTerms,
    }) menuWidget,
    String searchTerms,
  )? showDialogFn;

  /// [onSaved] as in FormField.
  final FormFieldSetter<T>? onSaved;

  /// [listValidator] [Function] with parameter: __List__ returning [String]
  /// displayed below selected value when not valid and null when valid.
  final String? Function(List<T?>)? listValidator;

  /// [autovalidateMode] as in FormField.
  final AutovalidateMode autovalidateMode;

  /// [restorationId] as in FormField.
  final String? restorationId;

  /// [giveMeThePop] [Function] to pass the pop function so that the menu or
  /// dialog can be closed from outside the widget.
  final Function(Function pop)? giveMeThePop;

  final Widget Function({
    required bool filter,
    required BuildContext context,
    required Function onPressed,
    int? nbFilters,
    bool? orderAsc,
    String? orderBy,
  })? buildFutureFilterOrOrderButton;

  final Widget Function({
    required List<Tuple3<int, DropdownMenuItem, bool>> itemsToDisplay,
    required ScrollController scrollController,
    required bool thumbVisibility,
    required Widget emptyListWidget,
    required void Function(int index, T value, bool itemSelected) itemTapped,
    required Widget Function(DropdownMenuItem item, bool isItemSelected)
        displayItem,
  })? searchResultDisplayFn;

  MultipleDropdown.multiple({
    Key? key,
    this.items,
    this.onChanged,
    this.selectedItems = const [],
    this.style,
    this.searchHint,
    this.hint,
    this.disabledHint,
    this.icon = const Icon(Icons.arrow_drop_down),
    this.underline,
    this.doneButton = "Done",
    this.label,
    this.closeButton = "Close",
    this.displayClearIcon = false,
    // this.clearIcon = const Icon(Icons.clear),
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.iconSize = 24.0,
    this.isExpanded = false,
    this.isCaseSensitiveSearch = false,
    this.searchFn,
    this.onClear,
    this.selectedValueWidgetFn,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.displayItem,
    this.dialogBox = true,
    this.menuConstraints,
    this.readOnly = false,
    this.menuBackgroundColor,
    this.rightToLeft,
    this.autofocus = true,
    this.selectedAggregateWidgetFn,
    this.padding,
    this.setOpenDialog,
    this.buildDropDownDialog,
    this.dropDownDialogPadding,
    this.searchInputDecoration,
    this.itemsPerPage,
    this.currentPage,
    this.customPaginationDisplay,
    this.futureSearchFn,
    this.futureSearchOrderOptions,
    this.futureSearchFilterOptions,
    this.futureSelectedValues,
    this.emptyListWidget,
    this.onTap,
    this.futureSearchRetryButton,
    this.searchDelay,
    this.fieldPresentationFn,
    this.fieldDecoration,
    // this.clearSearchIcon,
    this.showDialogFn,
    this.onSaved,
    this.listValidator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.restorationId,
    this.giveMeThePop,
    this.buildFutureFilterOrOrderButton,
    this.searchResultDisplayFn,
  })  : multipleSelection = true,
        value = null,
        super(
          key: key,
          builder: (FormFieldState<dynamic> state) {
            _MultipleDropdownState<T> sCState =
                state as _MultipleDropdownState<T>;
            return (sCState.buildWidget(sCState.context));
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: null,
          enabled: (items?.isNotEmpty ?? false || futureSearchFn != null) &&
              (onChanged != null || onChanged is Function),
          autovalidateMode: autovalidateMode,
          restorationId: restorationId,
        ) {
    checkPreconditions();
  }

  checkPreconditions() {
    assert(menuConstraints == null || !dialogBox);
    assert(itemsPerPage == null || currentPage != null,
        "currentPage must be given if itemsPerPage is given");
    assert(
        dropDownDialogPadding == null || buildDropDownDialog == null,
        "buildDropDownDialog and dropDownDialogPadding cannot be set at" +
            " the same time");

    assert(
        futureSearchOrderOptions == null || futureSearchFn != null,
        "futureSearchOrderOptions is of no use if futureSearchFn is not " +
            "set");
    assert(
        futureSearchFilterOptions == null || futureSearchFn != null,
        "futureSearchFilterOptions is of no use if futureSearchFn is not " +
            "set");
    assert(futureSearchFn == null || searchFn == null,
        "futureSearchFn and searchFn cannot work together");
    assert((futureSearchFn == null) != (items == null),
        "must either have futureSearchFn or items but not both");
    assert(
        futureSearchFn == null ||
            (multipleSelection
                ? (futureSelectedValues != null && value == null)
                : (true && futureSelectedValues == null)),
        "${multipleSelection ? "futureSelectedValues" : "value"} must be set if futureSearchFn is set in ${multipleSelection ? "multiple" : "single"} selection mode while ${multipleSelection ? "value" : "futureSelectedValues"} must not be set");
    assert(fieldDecoration == null || underline == null,
        "use either underline or fieldDecoration");
    assert(fieldPresentationFn == null || underline == null,
        "use either underline or fieldPresentationFn");
    assert(fieldPresentationFn == null || padding == null,
        "use either padding or fieldPresentationFn");
    assert(dialogBox || showDialogFn == null,
        "use showDialogFn only with dialogBox");
  }

  bool get isEnabled =>
      (items?.isNotEmpty ?? false || futureSearchFn != null) &&
      (onChanged != null || onChanged is Function);

  @override
  _MultipleDropdownState<T> createState() => _MultipleDropdownState<T>();
}

class _MultipleDropdownState<T> extends FormFieldState<T> {
  List<int>? selectedItems;
  PointerThisPlease<bool> displayMenu = PointerThisPlease<bool>(false);
  Function? updateParent;

  List<T> futureSelectedValues = [];

  Function? pop;

  @override
  MultipleDropdown<T> get widget => super.widget as MultipleDropdown<T>;

  bool get rightToLeft =>
      widget.rightToLeft ??
      Directionality.maybeOf(context) == TextDirection.rtl;

  void giveMeThePop(Function pop) {
    this.pop = pop;
    if (widget.giveMeThePop != null) {
      widget.giveMeThePop!(pop);
    }
  }

  TextStyle get _textStyle =>
      widget.style ??
      (_enabled && !(widget.readOnly)
          ? Theme.of(context).textTheme.titleMedium
          : Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: _disabledIconColor)) ??
      TextStyle();
  bool get _enabled => widget.isEnabled;

  Color? get _enabledIconColor {
    if (widget.iconEnabledColor != null) {
      return widget.iconEnabledColor;
    }
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.grey.shade700;
      case Brightness.dark:
        return Colors.white70;
    }
  }

  Color? get _disabledIconColor {
    if (widget.iconDisabledColor != null) {
      return widget.iconDisabledColor;
    }
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.grey.shade400;
      case Brightness.dark:
        return Colors.white10;
    }
  }

  Color? get _iconColor {
    // These colors are not defined in the Material Design spec.
    return (_enabled && !(widget.readOnly)
        ? _enabledIconColor
        : _disabledIconColor);
  }

  bool get valid {
    return (validResult == null);
  }

  String? get validResult {
    if (widget.listValidator != null) {
      return (widget.listValidator!(selectedResult));
    }
    if (widget.validator != null) {
      return (widget.validator!(selectedResult));
    }
    return (null);
  }

  bool get hasSelection {
    if (widget.futureSearchFn != null) {
      return (futureSelectedValues.isNotEmpty);
    }
    return (selectedItems != null && ((selectedItems?.isNotEmpty) ?? true));
  }

  dynamic get selectedResult {
    if (widget.futureSearchFn != null) {
      if (widget.multipleSelection) {
        return (futureSelectedValues);
      }
      if (futureSelectedValues.isNotEmpty) {
        return (futureSelectedValues.first);
      }
      return (null);
    }
    return (widget.multipleSelection
        ? selectedItems
        : selectedItems?.isNotEmpty ?? false
            ? widget.items![selectedItems?.first ?? 0].value
            : null);
  }

  void updateSelectedItems({dynamic sel = const NotGiven()}) {
    if (widget.futureSearchFn != null) {
      return;
    }
    List<int>? updatedSelectedItems;
    if (widget.multipleSelection) {
      if (!(sel is NotGiven)) {
        updatedSelectedItems = sel as List<int>;
      } else {
        updatedSelectedItems = List<int>.from(widget.selectedItems);
      }
    } else {
      T? val = !(sel is NotGiven) ? sel as T? : widget.value;
      if (val != null) {
        int? i = indexFromValue(val);
        if (i != null && i != -1) {
          updatedSelectedItems = [i];
        }
      } else {
        updatedSelectedItems = null;
      }
      if (updatedSelectedItems == null) updatedSelectedItems = [];
    }
    selectedItems?.retainWhere((element) =>
        updatedSelectedItems?.any((selected) => selected == element) ?? false);
    updatedSelectedItems.forEach((selected) {
      if (!(selectedItems?.any((element) => selected == element) ?? true)) {
        selectedItems?.add(selected);
      }
    });
  }
  // void updateSelectedItems({dynamic sel = const NotGiven()}) {
  //   if (widget.futureSearchFn != null) {
  //     return;
  //   }
  //   List<int>? updatedSelectedItems;
  //   if (widget.multipleSelection) {
  //     if (!(sel is NotGiven)) {
  //       updatedSelectedItems = sel as List<int>;
  //     } else {
  //       // FIX: Preserve current selectedItems during search operations
  //       // Instead of using widget.selectedItems which can be stale
  //       updatedSelectedItems = selectedItems != null
  //           ? List<int>.from(selectedItems!)
  //           : List<int>.from(widget.selectedItems);
  //     }
  //   } else {
  //     T? val = !(sel is NotGiven) ? sel as T? : widget.value;
  //     if (val != null) {
  //       int? i = indexFromValue(val);
  //       if (i != null && i != -1) {
  //         updatedSelectedItems = [i];
  //       }
  //     } else {
  //       updatedSelectedItems = null;
  //     }
  //     if (updatedSelectedItems == null) updatedSelectedItems = [];
  //   }

  //   // Initialize selectedItems if it's null
  //   selectedItems ??= [];

  //   selectedItems?.retainWhere((element) =>
  //       updatedSelectedItems?.any((selected) => selected == element) ?? false);
  //   updatedSelectedItems.forEach((selected) {
  //     if (!(selectedItems?.any((element) => selected == element) ?? true)) {
  //       selectedItems?.add(selected);
  //     }
  //   });
  // }

  void updateSelectedValues({dynamic sel = const NotGiven()}) {
    if (widget.futureSearchFn == null) {
      return;
    }
    List<T>? updatedFutureSelectedValues;
    if (widget.multipleSelection) {
      if (!(sel is NotGiven)) {
        updatedFutureSelectedValues = sel as List<T>;
      } else {
        updatedFutureSelectedValues =
            List<T>.from(widget.futureSelectedValues!);
      }
    } else {
      T? val = !(sel is NotGiven) ? sel as T : widget.value;
      if (val != null) {
        updatedFutureSelectedValues = [val];
      }
      if (updatedFutureSelectedValues == null) updatedFutureSelectedValues = [];
    }
    futureSelectedValues.retainWhere((element) =>
        updatedFutureSelectedValues?.any((selected) => selected == element) ??
        false);
    updatedFutureSelectedValues.forEach((selected) {
      if (!(futureSelectedValues.any((element) => selected == element))) {
        futureSelectedValues.add(selected);
      }
    });
  }

  int? indexFromValue(T value) {
    assert(widget.futureSearchFn == null,
        "got a futureSearchFn with a call to indexFromValue");
    return (widget.items!.indexWhere((item) {
      return (item.value == value);
    }));
  }

  void sendSelection(dynamic selection, [BuildContext? onChangeContext]) {
    if (widget.validator != null || widget.listValidator != null) {
      try {
        didChange(selection);
      } catch (e, st) {
        if (!widget.multipleSelection) {
          debugPrint(
              "Warning: didChange call threw an error: ${e.toString()} ${st.toString()} You may want to reconsider the declared types otherwise the form validation may not consider this field properly.");
        } else {
          // We should try to make this work in multiple selection as well
          // see https://github.com/lcuis/search_choices/issues/97
          debugPrint(
              "Warning: MultipleDropdown multipleSelection doesn't fully support Form didChange call.");
        }
      }
    }
    try {
      widget.onChanged!(selection);
    } catch (e) {
      try {
        widget.onChanged!(selection, onChangeContext);
      } catch (e) {
        try {
          widget.onChanged!(selection, pop);
        } catch (e) {
          try {
            widget.onChanged!(selection, onChangeContext, pop);
          } catch (e) {
            debugPrint(
                "Warning: Unexpected arguments passed while running sendSelection in search_choices.");
          }
        }
      }
    }
  }

  @override
  void initState() {
    if (widget.setOpenDialog != null) {
      widget.setOpenDialog!(showDialogOrMenu);
    }
    if (widget.futureSearchFn != null) {
      futureSelectedValues = [];
      if (widget.futureSelectedValues != null) {
        futureSelectedValues.addAll(widget.futureSelectedValues!);
      }
      updateParent = (sel) {
        if (!(sel is NotGiven)) {
          sendSelection(sel, context);
          updateSelectedValues(sel: sel);
        }
      };
      updateSelectedValues();
    } else {
      selectedItems = [];
      selectedItems?.addAll(widget.selectedItems);
      updateParent = (sel) {
        if (!(sel is NotGiven)) {
          sendSelection(sel, context);
          updateSelectedItems(sel: sel);
        }
      };
      updateSelectedItems();
    }
    super.initState();
  }

  updateParentWithOptionalPop(
    value, [
    bool pop = false,
  ]) {
    updateParent!(value);
    if (pop && this.pop != null) {
      this.pop!();
    }
  }

  @override
  void didUpdateWidget(MultipleDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.futureSearchFn != null) {
      updateSelectedValues();
    } else {
      updateSelectedItems();
    }
  }

  Widget menuWidget({String searchTerms = ""}) {
    return StatefulBuilder(
        builder: (BuildContext menuContext, StateSetter setStateFromBuilder) {
      return (DropdownDialog(
        items: widget.items,
        hint: prepareWidget(widget.searchHint),
        isCaseSensitiveSearch: widget.isCaseSensitiveSearch,
        // closeButton: widget.closeButton,
        keyboardType: widget.keyboardType,
        searchFn: widget.searchFn,
        multipleSelection: widget.multipleSelection,
        selectedItems: selectedItems,
        doneButton: widget.doneButton,
        displayItem: widget.displayItem,
        validator: widget.validator,
        dialogBox: widget.dialogBox,
        displayMenu: displayMenu,
        menuConstraints: widget.menuConstraints,
        menuBackgroundColor: widget.menuBackgroundColor,
        style: widget.style,
        iconEnabledColor: widget.iconEnabledColor,
        iconDisabledColor: widget.iconDisabledColor,
        callOnPop: () {
          giveMeThePop(() {});
          if (!widget.dialogBox &&
              widget.onChanged != null &&
              selectedResult != null) {
            sendSelection(selectedResult, menuContext);
          }
          setState(() {});
        },
        updateParent: (value) {
          updateParent!(value);
          setStateFromBuilder(() {});
        },
        rightToLeft: rightToLeft,
        autofocus: widget.autofocus,
        initialSearchTerms: searchTerms,
        buildDropDownDialog: widget.buildDropDownDialog,
        dropDownDialogPadding: widget.dropDownDialogPadding,
        searchInputDecoration: widget.searchInputDecoration,
        itemsPerPage: widget.itemsPerPage,
        currentPage: widget.currentPage,
        customPaginationDisplay: widget.customPaginationDisplay,
        futureSearchFn: widget.futureSearchFn,
        futureSearchOrderOptions: widget.futureSearchOrderOptions,
        futureSearchFilterOptions: widget.futureSearchFilterOptions,
        futureSelectedValues: futureSelectedValues,
        emptyListWidget: widget.emptyListWidget,
        onTap: widget.onTap,
        futureSearchRetryButton: widget.futureSearchRetryButton,
        searchDelay: widget.searchDelay,
        giveMeThePop: giveMeThePop,
        // clearSearchIcon: widget.clearSearchIcon,
        listValidator: widget.listValidator,
        buildFutureFilterOrOrderButton: widget.buildFutureFilterOrOrderButton,
        searchResultDisplayFn: widget.searchResultDisplayFn,
      ));
    });
  }

  Future<void> showDialogOrMenu(String searchTerms,
      {bool closeMenu = false}) async {
    if (widget.dialogBox) {
      if (widget.showDialogFn != null) {
        await widget.showDialogFn!(
          context,
          menuWidget,
          searchTerms,
        );
      } else {
        await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return (menuWidget(searchTerms: searchTerms));
            });
      }
      if (widget.onChanged != null && selectedResult != null) {
        try {
          sendSelection(selectedResult, context);
        } catch (e) {
          sendSelection(selectedResult);
        }
      }
    } else {
      displayMenu.value = !closeMenu;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Widget buildWidget(BuildContext context) {
    if (widget.setOpenDialog != null) {
      widget.setOpenDialog!(showDialogOrMenu);
    }
    final List<Widget> items =
        _enabled ? List<Widget>.from(widget.items ?? []) : <Widget>[];
    int? hintIndex;
    if (widget.hint != null ||
        (!_enabled &&
            prepareWidget(widget.disabledHint,
                    parameter: updateParentWithOptionalPop) !=
                null)) {
      final Widget? positionedHint = DropdownMenuItem<T>(
        child: (_enabled
                ? prepareWidget(widget.hint)
                : prepareWidget(widget.disabledHint,
                        parameter: updateParentWithOptionalPop) ??
                    prepareWidget(widget.hint)) ??
            SizedBox.shrink(),
      );
      hintIndex = items.length;
      items.add(DefaultTextStyle(
        style: _textStyle.copyWith(color: Theme.of(context).hintColor),
        child: ExcludeSemantics(
          child: IgnorePointer(
            child: positionedHint,
          ),
        ),
      ));
    }
    Widget innerItemsWidget;
    List<Widget> list = [];
    if (widget.futureSearchFn == null) {
      selectedItems?.forEach((item) {
        if (!(item is NotGiven)) {
          list.add(widget.selectedValueWidgetFn != null
              ? widget.selectedValueWidgetFn!(widget.items![item].value)
              : items[item]);
        }
      });
    } else {
      futureSelectedValues.forEach((element) {
        if (!(element is NotGiven)) {
          list.add(widget.selectedValueWidgetFn != null
              ? widget.selectedValueWidgetFn!(element)
              : element is String
                  ? Text(element)
                  : element);
        }
      });
    }
    if ((list.isEmpty && hintIndex != null) ||
        (list.length == 1 && list.first is NotGiven)) {
      innerItemsWidget = items[hintIndex ?? 0];
    } else {
      innerItemsWidget = widget.selectedAggregateWidgetFn != null
          ? widget.selectedAggregateWidgetFn!(list)
          : Column(
              children: list,
            );
    }
    final EdgeInsetsGeometry padding = ButtonTheme.of(context).alignedDropdown
        ? kAlignedButtonPadding
        : kUnalignedButtonPadding;
    Widget? clickable = !_enabled &&
            prepareWidget(widget.disabledHint,
                    parameter: updateParentWithOptionalPop) !=
                null
        ? prepareWidget(widget.disabledHint,
            parameter: updateParentWithOptionalPop)
        : InkWell(
            key: Key("clickableResultPlaceHolder"),
            //this key is used for running automated tests
            onTap: widget.readOnly || !_enabled
                ? null
                : () async {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    }
                    await showDialogOrMenu("",
                        closeMenu: !widget.dialogBox && displayMenu.value);
                  },
            child: Row(
              textDirection:
                  rightToLeft ? TextDirection.rtl : TextDirection.ltr,
              children: <Widget>[
                widget.isExpanded
                    ? Expanded(child: innerItemsWidget)
                    : innerItemsWidget,
                IconTheme(
                  data: IconThemeData(
                    color: _iconColor,
                    size: widget.iconSize,
                  ),
                  child:
                      prepareWidget(widget.icon, parameter: selectedResult) ??
                          SizedBox.shrink(),
                ),
              ],
            ));

    DefaultTextStyle result = DefaultTextStyle(
      style: _textStyle,
      child: Container(
        padding: padding.resolve(Directionality.of(context)),
        child: Row(
          textDirection: rightToLeft ? TextDirection.rtl : TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.isExpanded
                ? Expanded(child: clickable ?? SizedBox.shrink())
                : clickable ?? SizedBox.shrink(),
          ],
        ),
      ),
    );

    final double bottom = 0.0;
    String? validatorOutput = validResult;
    Widget? labelOutput = prepareWidget(widget.label, parameter: selectedResult,
        stringToWidgetFunction: (string) {
      return (Text(string,
          textDirection: rightToLeft ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(color: Colors.blueAccent, fontSize: 13)));
    });
    Widget? fieldPresentation;
    EdgeInsets treatedPadding = widget.padding is EdgeInsets
        ? widget.padding
        : EdgeInsets.all(widget.padding is int
            ? widget.padding.toDouble()
            : widget.padding ?? 10.0);
    if (widget.fieldPresentationFn != null) {
      fieldPresentation = widget.fieldPresentationFn!(
        result,
        selectionIsValid: valid,
      );
    } else if (widget.fieldDecoration != null) {
      fieldPresentation = Padding(
        padding: treatedPadding,
        child: Container(
          decoration: widget.fieldDecoration,
          child: result,
        ),
      );
    } else {
      fieldPresentation = Stack(
        children: <Widget>[
          Padding(
            padding: treatedPadding,
            child: result,
          ),
          widget.underline is NotGiven
              ? SizedBox.shrink()
              : Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: bottom,
                  child: prepareWidget(widget.underline,
                          parameter: selectedResult) ??
                      Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        valid ? Color(0xFFBDBDBD) : Colors.red,
                                    width: 0.0))),
                      ),
                ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        labelOutput ?? SizedBox.shrink(),
        fieldPresentation,
        ((validatorOutput == null)
            ? SizedBox.shrink()
            : Text(
                validatorOutput,
                textDirection:
                    rightToLeft ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(color: Colors.red, fontSize: 13),
              )),
        displayMenu.value ? menuWidget() : SizedBox.shrink(),
      ],
    );
  }

  void clearSelection() {
    if (widget.futureSearchFn == null) {
      selectedItems?.clear();
    } else {
      futureSelectedValues.clear();
    }
    if (widget.onChanged != null) {
      sendSelection(selectedResult, context);
    }
    if (widget.onClear != null) {
      widget.onClear!();
    }
    setState(() {});
  }
}

class MultiSelectDropdown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final List<T> initialSelectedValues;
  final ValueChanged<List<T>> onChanged;
  final String title;

  const MultiSelectDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.initialSelectedValues = const [],
    this.title = "Select items",
  }) : super(key: key);

  @override
  _MultiSelectDropdownState<T> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.initialSelectedValues);
  }

  void _openMultiSelectDialog() async {
    final List<T>? results = await showDialog<List<T>>(
      context: context,
      builder: (context) {
        return _MultiSelectDialog<T>(
          items: widget.items,
          initialSelectedValues: _selectedValues,
          title: widget.title,
        );
      },
    );

    if (results != null) {
      setState(() {
        _selectedValues = results;
      });
      widget.onChanged(_selectedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText =
        _selectedValues.isEmpty ? "Tap to select" : _selectedValues.join(", ");

    return InkWell(
      onTap: _openMultiSelectDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.title,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(displayText),
      ),
    );
  }
}

class _MultiSelectDialog<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final List<T> initialSelectedValues;
  final String title;

  const _MultiSelectDialog({
    Key? key,
    required this.items,
    required this.initialSelectedValues,
    required this.title,
  }) : super(key: key);

  @override
  State<_MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<_MultiSelectDialog<T>> {
  late List<T> _tempSelectedValues;

  @override
  void initState() {
    super.initState();
    _tempSelectedValues = List<T>.from(widget.initialSelectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            final value = item.value!;
            return CheckboxListTile(
              value: _tempSelectedValues.contains(value),
              title: item.child,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? checked) {
                setState(() {
                  if (checked == true) {
                    _tempSelectedValues.add(value);
                  } else {
                    _tempSelectedValues.remove(value);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _tempSelectedValues),
          child: const Text("DONE"),
        ),
      ],
    );
  }
}
