import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String? labelText;
  String? hintText;
  Widget? prefix_icon;
  Widget? suffix_icon;
  bool isObscureText;
  String? Function(String?)? validator;
  TextInputType? inputType;
  Function(String)? onchanged;
  int? maxLines;

  MyTextField({
    this.labelText,
    this.inputType,
    this.prefix_icon,
    this.suffix_icon,
    this.hintText,
    this.isObscureText = false,
    this.validator,
    this.maxLines = 1,
    this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(15),
      child: TextFormField(
        keyboardType: inputType,
        onChanged: onchanged,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0xFF555FD2))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color(0xFF555FD2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          prefixIcon: prefix_icon,
          hintText: hintText,
          label: Text(
            labelText!,
            style: TextStyle(
              color: Color(0xFF555FD2),
            ),
          ),
          alignLabelWithHint: true,
          suffixIcon: suffix_icon,
        ),
        obscureText: isObscureText,
      ),
    );
  }
}
