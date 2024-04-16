import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/utils/future_layout.dart';
import 'package:haru_admin/utils/tap.dart';

class ChapterInfoProvider extends ChangeNotifier {
  final String level;
  final int set_number;
  final int chapter_number;
  final String title;
  final String reference_data;

  ChapterInfoProvider({
    required this.level,
    required this.set_number,
    required this.chapter_number,
    required this.title,
    required this.reference_data,
  });
}

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  static const int Rows = 15;
  final List<int> columnWidth = [60, 60, 150, 100, 100, 220, 100, 80, 80];
  final tabletitle = [
    '',
    '레벨',
    '유형',
    '회차',
    '사이클',
    '타이틀',
    '상태',
    '수정',
    '퀴즈/테스트',
  ];
  final IntroDataRepository introRepository = IntroDataRepository();
  int currentPage = 0;
  final int rowsPerPage = 15;
  List<bool> isSelected = List.generate(10, (index) => false);

  Future<dynamic> fetchIntroDataList =
      Future.delayed(const Duration(milliseconds: 500), () {
    return IntroDataRepository().getIntroDataList(page: 0, size: Rows);
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text('인트로 데이터',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        DefaultFutureBuilder(
          future: fetchIntroDataList,
          height: 500,
          titleRow: Row(
            children: List.generate(
              tabletitle.length,
              (index) => buildTableColumn(
                  Text(
                    tabletitle[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  columnWidth,
                  index),
            ),
          ),
          childRow: (dynamic introData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: introData.content.length,
              itemBuilder: (context, index) {
                return Row(
                  children: List.generate(
                    tabletitle.length,
                    (index) => buildTableColumn(
                        [
                          Checkbox(
                              value: isSelected[index],
                              onChanged: (value) {
                                setState(() {
                                  isSelected[index] = value!;
                                });
                              }),
                          Text(introData.content[index].id.toString()),
                          Text(introData.content[index].category.toString()),
                          Text(introData.content[index].chapter.toString()),
                          Text(introData.content[index].chapter.toString()),
                          Text(introData.content[index].titleKor),
                          Text(introData.content[index].state),
                          TextButton(
                            onPressed: () {},
                            child: const Text('수정'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(
                                  '/test/add/${introData.content[index].id}');
                            },
                            child: const Text('퀴즈'),
                          ),
                        ][index],
                        columnWidth,
                        index),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
