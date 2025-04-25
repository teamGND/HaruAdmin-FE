import 'package:flutter/material.dart';
import 'package:haru_admin/themes/colors.dart';

enum DataStatus {
  WAIT,
  APPROVE,
  SHOW_USER;

  static DataStatus fromString(String status) {
    switch (status) {
      case 'WAIT':
        return WAIT;
      case 'APPROVE':
        return APPROVE;
      case 'SHOW_USER':
        return SHOW_USER;
      default:
        throw Exception('Unknown status: $status');
    }
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final DataStatus status;

  // background color
  Color getBackgroundColor() {
    switch (status) {
      case DataStatus.WAIT:
        return ColorPallete.lightRed;
      case DataStatus.APPROVE:
        return ColorPallete.lightGreen;
      case DataStatus.SHOW_USER:
        return ColorPallete.lightBlue;
    }
  }

  // text color
  Color getTextColor() {
    switch (status) {
      case DataStatus.WAIT:
        return ColorPallete.red;
      case DataStatus.APPROVE:
        return ColorPallete.green;
      case DataStatus.SHOW_USER:
        return ColorPallete.blue;
    }
  }

  // text
  String getText() {
    switch (status) {
      case DataStatus.WAIT:
        return "WAIT";
      case DataStatus.APPROVE:
        return "APPROVE";
      case DataStatus.SHOW_USER:
        return "SHOW USER";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 30,
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          getText(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: getTextColor(),
          ),
        ),
      ),
    );
  }
}
