import 'package:flutter/material.dart';

const List<String> typeList = ['총관리자', '콘텐츠 관리자', '번역 관리자'];

class RankArea extends StatefulWidget {
  const RankArea({super.key});

  @override
  State<RankArea> createState() => _RankAreaState();
}

class _RankAreaState extends State<RankArea> {
  String dropdownValue = typeList.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 750,
      child: Row(
        children: [
          const SizedBox(
            width: 130,
            child: Text(
              '요청 권한',
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
                  typeList.map<DropdownMenuEntry<String>>((String value) {
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
