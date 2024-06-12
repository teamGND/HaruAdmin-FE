import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/data_search_area.dart';

class ChapterCatalogTable extends StatelessWidget {
  final String? level;
  final int? cycle;
  final int? chapter;
  final String? title;

  const ChapterCatalogTable({
    super.key,
    required this.level,
    required this.cycle,
    required this.chapter,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 100,
      child: Column(
        children: [
          Row(
            children: [
              RequiredInfoName('레벨'),
              DataField(level ?? '?'),
              InfoName('사이클'),
              DataField(cycle != null ? cycle.toString() : ''),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              RequiredInfoName('타이틀'),
              DataField(title ?? ''),
              InfoName('회차'),
              DataField(chapter != null ? chapter.toString() : ''),
            ],
          ),
        ],
      ),
    );
  }
}
