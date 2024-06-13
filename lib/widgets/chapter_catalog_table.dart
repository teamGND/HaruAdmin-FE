import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/data_search_area.dart';

class ChapterCatalogTable extends StatelessWidget {
  final String? level;
  final int? cycle;
  final int? sets;
  final int? chapter;
  final String? title;

  const ChapterCatalogTable({
    super.key,
    required this.level,
    required this.cycle,
    required this.sets,
    required this.chapter,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 600,
      child: Column(
        children: [
          Row(
            children: [
              RequiredInfoName('레벨'),
              DataField(level ?? '?'),
              InfoName('사이클'),
              DataField(cycle != null ? cycle.toString() : ''),
              InfoName('세트'),
              DataField(sets != null ? sets.toString() : ''),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              InfoName('회차'),
              DataField(chapter != null ? chapter.toString() : ''),
              RequiredInfoName('타이틀'),
              DataField(title ?? '', isDoubled: true),
            ],
          ),
        ],
      ),
    );
  }
}
