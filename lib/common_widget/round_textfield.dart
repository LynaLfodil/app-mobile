import 'package:flutter/material.dart';
import '../common/color_extention.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String icon;
  final Widget? rightIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool autoFocus;
  final bool readOnly;
  final int? maxLines;
  final bool enabled;
  final Color? fillColor;
  final double borderRadius;

  const RoundTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.margin,
    this.keyboardType,
    this.obscureText = false,
    this.rightIcon,
    this.validator,
    this.onChanged,
    this.autoFocus = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.enabled = true,
    this.fillColor,
    this.borderRadius = 15, required String hitText, required TextButton rigtIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        autofocus: autoFocus,
        readOnly: readOnly,
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          color: enabled ? Tcolor.primary : Tcolor.grey,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? Tcolor.lightGrey,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Tcolor.primary2.withOpacity(0.5),
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Tcolor.grey,
            fontSize: 12,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: Tcolor.grey,
            ),
          ),
          suffixIcon: rightIcon,
          errorStyle: const TextStyle(
            color: Color.fromARGB(255, 127, 38, 32),
            fontSize: 11,
            height: 0.8,
          ),
        ),
      ),
    );
  }
}