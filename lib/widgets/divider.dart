import 'package:flutter/material.dart'; // 구분선

class LineDivider extends StatelessWidget {
  final double thick;

  const LineDivider({
    required this.thick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            height: thick,
            width: 750.00,
            color: const Color(0xFFD9D9D9),
          ),
        ),
      ],
    );
  }
}
