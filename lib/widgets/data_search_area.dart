import 'package:flutter/material.dart';

Widget InfoName(String categoryName) {
  return Container(
      width: 75,
      height: 45,
      alignment: Alignment.center,
      color: const Color(0xFFD9D9D9),
      child: Center(
        child: Text(
          categoryName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ));
}

Widget RequiredInfoName(String requiredCategory) {
  return Container(
    width: 75,
    height: 45,
    color: const Color(0xFFD9D9D9),
    alignment: Alignment.center,
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: requiredCategory,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
            children: const <TextSpan>[
              TextSpan(text: '*', style: TextStyle(color: Color(0xFFF05A2A)))
            ]),
      ),
    ),
  );
}

Widget DataField(String data, {bool isDoubled = false}) {
  return Container(
    width: isDoubled ? 285 : 100,
    height: 43,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    margin: const EdgeInsets.symmetric(horizontal: 5),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFD9D9D9),
      ),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      data,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
  );
}

class textformfield extends StatefulWidget {
  const textformfield({super.key});

  @override
  State<textformfield> createState() => _textformfieldState();
}

class _textformfieldState extends State<textformfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 120,
        height: 40,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
