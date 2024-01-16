import 'package:flutter/material.dart';

class BorderLine extends StatelessWidget {
  final double thickness;
  const BorderLine({
    super.key,
    required this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: thickness,
          width: 643.00,
          color: const Color(0xFFD9D9D9),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
