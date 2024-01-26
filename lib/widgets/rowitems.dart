import 'package:flutter/material.dart'; //sign_up 페이지 칸 한 개에 대한 정의

class RowItems extends StatefulWidget {
  final String infoname;
  final Widget? widget;
  final double? width;
  final Widget? textbutton;

  const RowItems({
    super.key,
    required this.infoname,
    this.widget,
    this.width,
    this.textbutton,
  });

  @override
  State<RowItems> createState() => _RowItemsState();
}

class _RowItemsState extends State<RowItems> {
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
            child: TextFormField(),
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
