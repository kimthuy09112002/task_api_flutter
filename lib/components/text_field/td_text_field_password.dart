import 'package:flutter/material.dart';
import 'package:task_api_flutter/resources/app_color.dart';

class TdTextFieldPassword extends StatefulWidget {
  const TdTextFieldPassword({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    required this.hintText,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String hintText;
  // final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  // final bool readOnly;

  @override
  State<TdTextFieldPassword> createState() => _TdTextFieldPasswordState();
}

class _TdTextFieldPasswordState extends State<TdTextFieldPassword> {
  bool showPassword = false;

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
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: !showPassword,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
        filled: true,
        fillColor: Colors.pink.shade50,
        border: border,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColor.grey),
        labelText: widget.hintText,
        prefixIcon: const Icon(Icons.password, color: AppColor.orange),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => showPassword = !showPassword),
          child: showPassword
              ? Icon(Icons.remove_red_eye_rounded,
                  color: AppColor.brown.withOpacity(0.68))
              : const Icon(Icons.remove_red_eye_outlined,
                  color: AppColor.green),
        ),
      ),
    );
  }
}
