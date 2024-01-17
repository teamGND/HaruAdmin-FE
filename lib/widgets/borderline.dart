import 'package:flutter/material.dart';

class BorderLine extends StatelessWidget {
  final double thick;

  const BorderLine({
    super.key,
    required this.thick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: thick,
          width: 650.00,
          color: const Color(0xFFD9D9D9),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
