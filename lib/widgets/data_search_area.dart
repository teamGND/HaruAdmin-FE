import 'package:flutter/material.dart';

Widget InfoName(String categoryName) {
  return Container(
      padding: const EdgeInsets.only(top: 10.0),
      width: 100,
      height: 55,
      color: const Color(0xFFD9D9D9),
      child: Text(
        categoryName,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
      ));
}

Widget RequiredInfoName(String requiredCategory) {
  return Container(
    padding: const EdgeInsets.only(top: 10.0),
    width: 100,
    height: 55,
    color: const Color(0xFFD9D9D9),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: requiredCategory,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
          children: const <TextSpan>[
            TextSpan(text: '*', style: TextStyle(color: Color(0xFFF05A2A)))
          ]),
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
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ));
  }
}
