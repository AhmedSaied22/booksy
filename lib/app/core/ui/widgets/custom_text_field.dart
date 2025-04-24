import 'package:booksy/app/core/extensions/font_styles_extensions.dart';
import 'package:booksy/app/core/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final int? maxLines;
  final bool obscureText;
  final bool showLabel;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool isValidator;
  final Color? fillColor;
  final Widget? icon;
  final TextStyle? labelStyle;
  final double? borderRadius;
  final EdgeInsetsGeometry? prefixPadding;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? minLines;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    this.hintText,
    this.errorText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onTap,
    this.showLabel = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.readOnly = false,
    this.prefixIconColor,
    this.onChanged,
    this.isValidator = false,
    this.focusNode,
    this.suffixIconColor,
    this.borderRadius,
    this.prefixPadding,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.minLines,
    this.labelStyle,
    this.onFieldSubmitted,
    this.hintStyle,
    this.fillColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: context.bodyLarge,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      onTap: onTap,
      minLines: minLines,
      focusNode: focusNode,
      initialValue: initialValue,
      readOnly: readOnly,
      controller: controller,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator ??
          (value) {
            if (isValidator) {
              if (value == null || value.trim().isEmpty) {
                return "هذا الحقل مطلوب.";
              }
            }
            return null;
          },
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      obscuringCharacter: "*",
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      decoration: InputDecoration(
        icon: icon,
        labelStyle: labelStyle,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        errorText: errorText,
        labelText: showLabel && controller != null ? hintText : null,
        hintText: hintText,
        fillColor: fillColor ?? AppColors.scaffoldBackgroundColor,
        hintStyle: hintStyle ?? context.hintText,
        prefixIcon: prefixIcon,
        prefix: prefixIcon == null
            ? const SizedBox(
                width: 10,
              )
            : null,
        filled: true,
        prefixIconColor: prefixIconColor,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
      ),
    );
  }
}
