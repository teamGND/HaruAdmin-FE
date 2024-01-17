import 'package:flutter/material.dart';

const List<String> TypeList = ['총관리자', '콘텐츠 관리자', '번역 관리자'];

class AuthorityArea extends StatefulWidget {
  const AuthorityArea({super.key});

  @override
  State<AuthorityArea> createState() => _AuthorityAreaState();
}

class _AuthorityAreaState extends State<AuthorityArea> {
  String dropdownValue = TypeList.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 130,
            child: Text(
              '요청 권한',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 330,
            child: DropdownMenu<String>(
              width: 330,
              hintText: '관리자 유형을 선택해주세요.',
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  TypeList.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                  style: ButtonStyle(
                    surfaceTintColor:
                        MaterialStateProperty.all(const Color(0xFFD9D9D9)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
