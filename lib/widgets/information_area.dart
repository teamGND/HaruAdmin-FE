import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/textbutton.dart';

class InformantionArea extends StatelessWidget {
  final String infoname;
  final bool hideword;
  final String memo;
  final double Width;

  const InformantionArea({
    super.key,
    required this.infoname,
    required this.hideword,
    required this.memo,
    required this.Width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 750,
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              infoname,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            width: 75,
          ),
          SizedBox(
            width: Width,
            child: TextField(
              obscureText: hideword,
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
          ),
        ],
      ),
    );
  }
}
