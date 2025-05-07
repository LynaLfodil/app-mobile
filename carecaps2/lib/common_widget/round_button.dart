import 'package:flutter/material.dart';

import '../common/color_extention.dart';

enum RoundButtonType { bgGradient, bgSGradient, textGradient, solid }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;
  final Color? backgroundColor;
  final Color? textColor;
  final String? textFontFamily;

  const RoundButton({
    super.key,
    required this.title,
    this.type = RoundButtonType.bgGradient,
    this.fontSize = 16,
    this.elevation = 1,
    this.fontWeight = FontWeight.w700,
    this.backgroundColor,
    this.textColor,
    this.textFontFamily,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isGradient = type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient;
    bool isTextGradient = type == RoundButtonType.textGradient;

    return Container(
      decoration: isGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: type == RoundButtonType.bgSGradient
                    ? Tcolor.secondaryG
                    : Tcolor.primaryG,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.5,
                  offset: Offset(0, 0.5),
                ),
              ],
            )
          : null,
      child: MaterialButton(
        onPressed: onPressed,
        height: 45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textColor: textColor ?? Tcolor.primary,
        minWidth: double.maxFinite,
        elevation: isGradient ? 0 : elevation,
        color: isGradient ? Colors.transparent : (backgroundColor ?? Tcolor.primary),
        child: isTextGradient
            ? ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: Tcolor.primaryG,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(
                    Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                  );
                },
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontFamily: textFontFamily ?? 'Poppins',
                  ),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  color: textColor ?? Tcolor.white,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontFamily: textFontFamily ?? 'Poppins',
                ),
              ),
      ),
    );
  }
}
