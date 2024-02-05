import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/colors.dart'; //sign_up 페이지 칸 한 개에 대한 정의

enum RankLabel {
  MASTER('MASTER', '총 관리자'),
  CONTENTS('CONTENTS', '컨텐츠 관리자'),
  TRANSLATION('TRANSLATION', '번역관리자');

  const RankLabel(this.englabel, this.korlabel);
  final String englabel;
  final String korlabel;
}

class RowItems extends StatefulWidget {
  final String infoname;
  final Widget? widget;
  final double? width;
  final Widget? textbutton;
  final String? hintText;
  final String? errorText;
  final bool useDropdownMenu;
  final bool obscureText;
  final Function(String?)? onSaved;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const RowItems({
    super.key,
    required this.infoname,
    this.widget,
    this.width,
    this.textbutton,
    this.errorText,
    this.onChanged,
    this.hintText,
    this.onSaved,
    required this.obscureText,
    required this.useDropdownMenu,
    required this.controller,
    required this.validator,
  });

  @override
  State<RowItems> createState() => _RowItemsState();
}

class _RowItemsState extends State<RowItems> {
  RankLabel? selectedRank;
  TextEditingController rankController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 65, //
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              widget.infoname,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: widget.useDropdownMenu
                ? DropdownMenu<RankLabel>(
                    initialSelection: null,
                    width: MediaQuery.of(context).size.width * 0.2,
                    hintText: selectedRank == null
                        ? '관리자 유형을 선택해주세요'
                        : '${selectedRank?.korlabel}',
                    requestFocusOnTap: true,
                    enableFilter: true,
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                    ),
                    onSelected: (RankLabel? rank) {
                      setState(() {
                        selectedRank =
                            rank; //RankLabel.CONTENTS, RankLabel.~~~라고 각각 타입별로 찍히긴 찍힘
                        print(selectedRank);
                      });
                    },
                    dropdownMenuEntries: RankLabel.values
                        .map<DropdownMenuEntry<RankLabel>>((RankLabel rank) {
                      return DropdownMenuEntry<RankLabel>(
                        value: rank,
                        label: rank.korlabel,
                        style: ButtonStyle(
                          surfaceTintColor:
                              MaterialStateProperty.all(greycolor),
                        ),
                      );
                    }).toList(),
                  )
                : TextFormField(
                    obscureText: widget.obscureText ? true : false,
                    controller: widget.controller,
                    validator: widget.validator,
                    decoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: hintTextColor, fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: widget.errorText),
                    onChanged: widget.onChanged,
                  ),
          ),
          SizedBox(
            width: widget.width,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.08,
            child: widget.textbutton,
          ),
        ],
      ),
    );
  }
}
