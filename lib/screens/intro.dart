import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  static const int Rows = 10;
  final tabletitle = ['', '레벨', '유형', '회차', '타이틀', '목차내용', '상태', '수정'];

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        Text('인트로 데이터',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    return tabletitle.map((String columnName) {
      return DataColumn(
        label: Text(
          columnName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }
}
