import 'package:flutter/material.dart';

class textFormField extends StatefulWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String? errorText;
  void setState;

  textFormField(
      {super.key,
      required this.obscureText,
      required this.controller,
      required this.errorText,
      required this.setState});

  @override
  State<textFormField> createState() => _textFormFieldState();
}

class _textFormFieldState extends State<textFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
          errorText: widget.errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      onChanged: (value) {
        setState(() {
          widget.setState;
        });
        widget.controller;
      },
      validator: (value) {
        value != null;
        return null;
      },
    );
  }
}
