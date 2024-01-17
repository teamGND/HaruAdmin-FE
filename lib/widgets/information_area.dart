import 'package:flutter/material.dart';

class InformantionArea extends StatelessWidget {
  final String infoname;

  final bool hideword;
  final String memo;

  const InformantionArea({
    super.key,
    required this.infoname,
    required this.hideword,
    required this.memo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              infoname,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 330,
            child: TextField(
              obscureText: hideword,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: memo,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFD9D9D9),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
