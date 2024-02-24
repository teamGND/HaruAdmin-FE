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
  final bool obscureText;
  final selectRank;
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
    this.selectRank,
    required this.obscureText,
    required this.controller,
    required this.validator,
  });

  @override
  State<RowItems> createState() => _RowItemsState();
}

class _RowItemsState extends State<RowItems> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65, //
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              widget.infoname,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
              width: widget.width ?? MediaQuery.of(context).size.width * 0.4,
              child: TextFormField(
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
                  onChanged: widget.onChanged)),
          widget.textbutton ??
              const SizedBox(
                width: 0,
              ),
        ],
      ),
    );
  }
}
