import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/textbutton.dart';

class IdArea extends StatefulWidget {
  const IdArea({super.key});

  @override
  State<IdArea> createState() => _IdAreaState();
}

class _IdAreaState extends State<IdArea> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 750,
      child: Row(
        children: [
          const SizedBox(
            width: 130,
            child: Text(
              '아이디',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            width: 75,
          ),
          SizedBox(
            width: 330,
            child: TextField(
              obscureText: false,
              decoration: InputDecoration(
                hintText: '',
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
          const SizedBox(
            width: 10,
          ),
          const TextButtons(
              buttonName: '중복확인',
              buttonColor: Color(0xFF9C9C9C),
              seroPadding: 20,
              garoPadding: 10,
              fontSize: 20),
        ],
      ),
    );
  }
}
