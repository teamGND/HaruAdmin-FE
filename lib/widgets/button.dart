import 'package:flutter/material.dart';

enum ButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class ClickableButton extends StatelessWidget {
  const ClickableButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.text,
    this.size = ButtonSize.medium,
  });

  final VoidCallback onPressed;
  final Color color;
  final String text;
  final ButtonSize size;

  // button size
  double get buttonSize {
    switch (size) {
      case ButtonSize.small:
        return 50;
      case ButtonSize.medium:
        return 100;
      case ButtonSize.large:
        return 200;
      case ButtonSize.extraLarge:
        return 380;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: buttonSize,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
