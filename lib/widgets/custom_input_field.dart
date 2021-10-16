import 'package:flutter/material.dart';

import '../constant.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function onFieldSubmitted;
  final Function validator;
  final String labelText;
  final TextInputType keybordType;

  const CustomInputField({
    this.controller,
    this.onFieldSubmitted,
    this.validator,
    this.labelText,
    this.keybordType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keybordType,
      textInputAction: TextInputAction.next,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: labelText,
          contentPadding: const EdgeInsets.all(kPadding)),
    );
  }
}
