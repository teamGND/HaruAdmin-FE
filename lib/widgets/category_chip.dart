import 'package:flutter/material.dart';
import 'package:haru_admin/themes/colors.dart';

enum Category {
  ALPHABET,
  WORD,
  GRAMMAR,
  TEST,
  MIDTERM;

  static Category fromString(String category) {
    switch (category) {
      case 'ALPHABET':
        return ALPHABET;
      case 'WORD':
        return WORD;
      case 'GRAMMAR':
        return GRAMMAR;
      case 'TEST':
        return TEST;
      case 'MIDTERM':
        return MIDTERM;
      default:
        throw Exception('Unknown category: $category');
    }
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
  });

  final Category category;

  Color getColor() {
    switch (category) {
      case Category.ALPHABET:
        return Colors.white;
      case Category.WORD:
        return ColorPallete.wordColor;
      case Category.GRAMMAR:
        return ColorPallete.grammarColor;
      case Category.TEST:
        return ColorPallete.testColor;
      case Category.MIDTERM:
        return Colors.black;
    }
  }

  String getText() {
    switch (category) {
      case Category.ALPHABET:
        return 'A';
      case Category.WORD:
        return 'W';
      case Category.GRAMMAR:
        return 'G';
      case Category.TEST:
        return 'T';
      case Category.MIDTERM:
        return 'M';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23,
      height: 23,
      decoration: BoxDecoration(
        color: getColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        getText(),
        style: TextStyle(
          color: category != Category.ALPHABET ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
