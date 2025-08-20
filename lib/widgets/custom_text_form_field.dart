import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    this.onChange,
    required this.labelText,
    required this.hintText,
    this.obscureText = false
  });
  final String labelText;
  final String hintText;
  bool? obscureText;
  Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field is required';
        }
      },
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
