import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_task_app/constants/colors.dart';

import '../mvvm/view models/input_field_view_model.dart';

class InputTextField extends ConsumerWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String hintText;
  final bool isPasswordObscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.isPasswordObscure = false,
  });

  _textStyle(Color color) => TextStyle(
      // fontFamily: poppins,
      fontWeight: FontWeight.w400,
      fontSize: 20,
      color: color);

  _border() => UnderlineInputBorder(borderSide: BorderSide(color: greyColor));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldKey = hintText.toLowerCase();
    final isObscure = ref.watch(inputFieldProvider)[fieldKey] ?? false;
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: _textStyle(whiteColor),
        cursorColor: whiteColor,
        obscureText: isObscure,
        decoration: InputDecoration(
          suffixIcon: isPasswordObscure
              ? GestureDetector(
                  onTap: () =>
                      ref.read(inputFieldProvider.notifier).toggle(fieldKey),
                  child: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Color(0xff606265),
                  ),
                )
              : suffixIcon,
          hintStyle: _textStyle(greyColor),
          hintText: hintText,
          border: _border(),
          focusedBorder: _border(),
        ),
        validator: validator);
  }
}
