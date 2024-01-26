import 'package:flutter/material.dart'; // 구분선

class LineDivider extends StatelessWidget {
  final double thick;

  const LineDivider({
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
          width: 750.00,
          color: const Color(0xFFD9D9D9),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
