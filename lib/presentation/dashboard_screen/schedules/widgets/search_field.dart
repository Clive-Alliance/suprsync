import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';

class CustomSearchField extends StatelessWidget {
  final void Function(String)? onChanged;
  final String? initialValue;
  final String? heading;
  final TextEditingController? controller;
  final void Function()? onTap;
  final String? hint;
  final int? maxLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Widget? preficIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool autocorrect;
  final bool optional;
  final bool obscureText;
  final Color? fillColor;
  final Color? borderColor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  const CustomSearchField({
    this.onChanged,
    super.key,
    this.initialValue,
    this.heading,
    this.controller,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforcement,
    this.hint,
    this.preficIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.autocorrect = true,
    this.optional = false,
    this.obscureText = false,
    this.fillColor,
    this.borderColor,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters = const [],
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(heading!),
          const SizedBox(height: 10),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          style: context.textTheme.bodyMedium,
          obscureText: obscureText,
          obscuringCharacter: '*',
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
          autocorrect: autocorrect,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF8F7F7),
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: preficIcon,
            suffixIcon: suffixIcon,
            hintText: hint,
            hintStyle: context.textTheme.bodyMedium
                ?.copyWith(color: const Color(0xffABABAB)),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? context.colorScheme.primary),
              borderRadius: BorderRadius.circular(18),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? context.colorScheme.primary),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          validator: optional ? null : validator,
        ),
      ],
    );
  }
}
