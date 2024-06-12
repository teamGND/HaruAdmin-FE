import 'package:haru_admin/utils/enum_type.dart';

class AddChatperClass {
  bool isExisting;
  int? id;
  CATEGORY? category;
  LEVEL? level;
  int? cycle;
  int? sets;
  int? chapter;
  String? title;
  List<String>? wordList;

  AddChatperClass({
    required this.isExisting,
    this.id,
    this.category,
    this.level,
    this.cycle,
    this.sets,
    this.chapter,
    this.title,
    this.wordList,
  });
}
