import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/provider/intro_provider.dart';
import 'package:haru_admin/widgets/data_search_area.dart';

class ChapterCatalogTable extends ConsumerWidget {
  final String? level;
  final int? cycle;
  final int? sets;
  final int? chapter;
  final TextEditingController titleController;

  const ChapterCatalogTable({
    super.key,
    required this.level,
    required this.cycle,
    required this.sets,
    required this.chapter,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Container(
                width: 285,
                height: 43,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD9D9D9),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    ref.read(introProvider.notifier).update(title: value);
                  },
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
