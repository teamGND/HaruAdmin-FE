import 'package:flutter/material.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/widgets/gaps.dart';

class AuthInput extends StatelessWidget {
  const AuthInput(
      {super.key,
      required this.adminIdController,
      required this.label,
      required this.hint,
      required this.validator});

  final TextEditingController adminIdController;
  final String label;
  final String hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Gaps.h20,
          Expanded(
            child: TextField(
              controller: adminIdController,
              obscureText: label.contains('비밀번호') ? true : false,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFFBDBDBD),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
          ),
          Gaps.h32,
        ],
      ),
    );
  }
}
