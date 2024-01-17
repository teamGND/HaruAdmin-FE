import 'package:flutter/material.dart';

class PhoneNumberArea extends StatelessWidget {
  const PhoneNumberArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 650,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '연락처',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 330,
            child: Row(
              children: [
                NumberBlank(
                  zero: '000',
                ),
                Icon(Icons.remove),
                NumberBlank(
                  zero: '0000',
                ),
                Icon(Icons.remove),
                NumberBlank(
                  zero: '0000',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NumberBlank extends StatelessWidget {
  final String zero;
  const NumberBlank({
    super.key,
    required this.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 93,
      child: TextField(
        decoration: InputDecoration(
          hintText: zero,
          hintStyle: const TextStyle(
            fontSize: 15,
            color: Color(0xFFD9D9D9),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
