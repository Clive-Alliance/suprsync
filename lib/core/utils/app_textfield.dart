import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class CustomAuthTextField extends StatefulWidget {
  const CustomAuthTextField(
      {Key? key,
      this.onChanged,
      this.hintText,
      this.label,
      this.fillCenter = true,
      this.isEnabled = true,
      this.textEditingController,
      this.errorMessage,
      this.suffixIcon,
      this.enableInteraction = false,
      this.prefixIcon,
      this.validator,
      this.isNotValid = false,
      this.obscureText = false,
      this.inputRadius = 4.0,
      this.maxLine = 1})
      : super(key: key);

  final void Function(String)? onChanged;
  final String? hintText;
  final String? label;
  final bool fillCenter;
  final bool enableInteraction;

  final bool isEnabled;
  final bool isNotValid;
  final double inputRadius;
  final String? errorMessage;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLine;
  final bool obscureText;
  final TextEditingController? textEditingController;

  @override
  _CustomAuthTextFieldState createState() => _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends State<CustomAuthTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Rebuild the widget when focus changes to update the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxLine == 1 ? 50 : 100,
      child: TextFormField(
        onChanged: widget.onChanged,
        textAlign: TextAlign.start,
        obscureText: widget.obscureText,
        validator: widget.validator,
        maxLines: widget.maxLine,
        controller: widget.textEditingController,
        enabled: widget.isEnabled,
        cursorColor: const Color(0xffC4C2C2),
        focusNode: _focusNode,
        enableInteractiveSelection: widget.enableInteraction,
        style: const TextStyle(
            fontFamily: 'Circular',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff000000)),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.label,

          floatingLabelStyle: const TextStyle(color: Colors.green),
          errorText: widget.errorMessage,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          hintStyle: context.textTheme.bodySmall?.copyWith(
              color: widget.hintText != 'English Language'
                  ? Color(0xffC4C2C2)
                  : Color(0xff000000)),
          contentPadding: const EdgeInsets.only(bottom: 0.0, left: 15),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xffDEDEDE), width: 24),
          ),

          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xffDEDEDE), width: 1),
          ),
          // er
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xffDEDEDE), width: 1),
          ),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Color(0xffDEDEDE), width: 1)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color(0xffDEDEDE), width: 1),
          ),
        ),
      ),
    );
  }
}
