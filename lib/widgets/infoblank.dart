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
          const SizedBox(
            width: 270,
            child: TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
            )),
          ),
        ],
      ),
    );
  }
}
