import 'package:flutter/material.dart';
import 'package:haru_admin/utils/enum_type.dart';

class LevelDropdown extends StatefulWidget {
  const LevelDropdown({super.key});

  @override
  State<LevelDropdown> createState() => _LevelDropdownState();
}

class _LevelDropdownState extends State<LevelDropdown> {
  bool _isDropdownOpen = false;
  LEVEL dropdownValue = LEVEL.LEVEL1;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      enableSearch: false,
      width: 160,
      trailingIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xFF585858),
      ),
      initialSelection: dropdownValue.toString(),
      onSelected: (value) {
        setState(() {
          dropdownValue = value as LEVEL;
          _isDropdownOpen = false;
        });
      },
      selectedTrailingIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: Color(0xFF585858),
      ),
      dropdownMenuEntries: LEVEL.values.map((value) {
        return DropdownMenuEntry<String>(
          value: value.toString(),
          label: value.toString().split('.')[1],
          // label 스타일
          labelWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value.toString().split('.')[1],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF585858),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
