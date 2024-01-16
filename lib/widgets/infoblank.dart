import 'package:flutter/material.dart';

class InfoBlank extends StatelessWidget {
  final String infoname;
  final TextAlign textalign;
  final bool hideword;

  const InfoBlank({
    super.key,
    required this.infoname,
    required this.textalign,
    required this.hideword,
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
            width: 270,
            child: TextField(
                obscureText: hideword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                )),
          ),
        ],
      ),
    );
  }
}
