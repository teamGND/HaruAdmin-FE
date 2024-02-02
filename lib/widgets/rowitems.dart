import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/colors.dart'; //sign_up 페이지 칸 한 개에 대한 정의

enum Rank {
  master('총 관리자'),
  content('콘텐츠 관리자'),
  translation('번역 관리자');

  const Rank(this.rankname);
  final String rankname;
}

class RowItems extends StatefulWidget {
  final String infoname;
  final Widget? widget;
  final double? width;
  final Widget? textbutton;
  final bool obscureText;
  final String? hintText;
  final String? errorText;
  final bool useDropdownMenu;
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
    required this.useDropdownMenu,
    required this.controller,
    required this.obscureText,
    required this.validator,
  });

  @override
  State<RowItems> createState() => _RowItemsState();
}

class _RowItemsState extends State<RowItems> {
  late Rank selectedRank;

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
                ? DropdownMenu<Rank>(
                    width: MediaQuery.of(context).size.width * 0.2,
                    initialSelection: null,
                    hintText: '관리자 유형을 선택해주세요.',
                    onSelected: (Rank? rankname) {
                      setState(() {
                        selectedRank = Rank.content;
                        rankname == null ? '요청 권한을 선택해주세요' : null;
                      });
                    },
                    dropdownMenuEntries: Rank.values
                        .map<DropdownMenuEntry<Rank>>((Rank rankname) {
                      return DropdownMenuEntry<Rank>(
                        value: rankname,
                        label: rankname.rankname,
                        style: ButtonStyle(
                          surfaceTintColor: MaterialStateProperty.all(
                              const Color(0xFFD9D9D9)),
                        ),
                      );
                    }).toList(),
                  )
                : TextFormField(
                    obscureText: widget.obscureText,
                    controller: widget.controller,
                    validator: widget.validator,
                    decoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: hintTextColor, fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorText: widget.errorText),
                    onChanged: widget.onChanged),
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
