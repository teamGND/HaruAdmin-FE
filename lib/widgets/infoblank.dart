import 'package:flutter/material.dart';

class InfoBlank extends StatelessWidget {
  final String infoname;
  final TextAlign textalign;

  const InfoBlank({
    super.key,
    required this.infoname,
    required this.textalign,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              infoname,
              textAlign: textalign,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          SizedBox(
            width: 300,
            child: Container(
              width: 270,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xff9C9C9C),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
