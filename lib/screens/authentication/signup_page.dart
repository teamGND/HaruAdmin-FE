import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/borderline.dart';

import 'package:haru_admin/widgets/infoblank.dart';

const List<String> list = <String>['총관리자', '콘텐츠 관리자', '번역 관리자'];

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Text(
            'HaruHangeul\nAdmin Page\nAdmin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const BorderLine(
            thickness: 2,
          ),
          const InfoBlank(
            infoname: '아이디',
            textalign: TextAlign.start,
          ),
          const BorderLine(
            thickness: 1,
          ),
          const InfoBlank(
            infoname: '비밀번호',
            textalign: TextAlign.start,
          ),
          const BorderLine(
            thickness: 1,
          ),
          const InfoBlank(
            infoname: '비밀번호 확인',
            textalign: TextAlign.start,
          ),
          const BorderLine(
            thickness: 1,
          ),
          const DropdownButton(),
          const BorderLine(
            thickness: 1,
          ),
          const InfoBlank(
            infoname: '이름',
            textalign: TextAlign.start,
          ),
          const BorderLine(
            thickness: 1,
          ),
          const InfoBlank(
            infoname: '연락처',
            textalign: TextAlign.start,
          ),
          const BorderLine(
            thickness: 2,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '이전으로',
              ))
        ],
      ),
    );
  }
}

class DropdownButton extends StatefulWidget {
  const DropdownButton({super.key});

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      width: 270,
      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        surfaceTintColor: MaterialStatePropertyAll(
          Color(0xFFD9D9D9),
        ),
        elevation: MaterialStatePropertyAll(5),
      ),
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
