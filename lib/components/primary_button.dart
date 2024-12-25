import 'package:flutter/material.dart';

import '../constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String? label;
  final Widget? widget;
  final double? height;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backGroundColor;
  final Color? textColor;
  final double? width;
  final AlignmentGeometry? alignment;
  final double? borderRadius;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    this.label,
    this.onTap,
    this.padding,
    this.borderColor,
    this.borderRadius = 20.0,
    this.backGroundColor,
    this.textColor,
    this.height,
    this.width,
    this.alignment,
    this.textStyle,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
        alignment: alignment,
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          border: Border.all(
            width: 1,
            color: borderColor ?? yellowColor,
          ),
        ),
        child: widget ??
            Text(
              label ?? '',
              style: textStyle ??
                  TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: whiteColor),
            ),
      ),
    );
  }
}
