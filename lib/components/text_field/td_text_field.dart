import 'package:flutter/material.dart';
import 'package:task_api_flutter/resources/app_color.dart';

class TdTextField extends StatelessWidget {
  const TdTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    required this.hintText,
    this.prefixIcon,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String hintText;
  final Icon? prefixIcon;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.red, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    );

    const focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.blue, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    );

    const enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.orange, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
        filled: true,
        fillColor: Colors.pink.shade50,
        border: border,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColor.grey),
        labelText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
