import 'package:flutter/material.dart';

class TextInputUtil extends StatelessWidget {
  TextEditingController controller;
  bool obscureText;
  String hintText;
  int maxLines;
  var validator;

  TextInputUtil(
      {Key? key,
      required this.controller,
      this.obscureText = false,
      this.hintText = '',
      this.maxLines = 1,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: 320,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
