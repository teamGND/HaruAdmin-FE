import 'package:flutter/material.dart';

Widget buildTableColumn(Widget widget, List<int> columnWidths, int index) {
  if (index == columnWidths.length) {
    return Expanded(
      child: SizedBox(
        child: widget,
      ),
    );
  } else {
    return SizedBox(
      width: columnWidths[index].toDouble(),
      child: widget,
    );
  }
}
