import 'package:flutter/material.dart';

class TextButtons extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;
  final double seroPadding;
  final double garoPadding;
  final double fontSize;

  const TextButtons({
    super.key,
    required this.buttonName,
    required this.buttonColor,
    required this.seroPadding,
    required this.garoPadding,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: garoPadding,
          vertical: seroPadding,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onPressed: () {},
      child: Text(
        buttonName,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
