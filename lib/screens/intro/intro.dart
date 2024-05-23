import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/utils/future_layout.dart';
import 'package:haru_admin/utils/tap.dart';
import 'package:haru_admin/widgets/button.dart';

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
  static const int Rows = 15;
  int currentPage = 0;
  List<bool> isSelected = List.generate(Rows, (index) => false);

  Future<dynamic> fetchIntroDataList =
      Future.delayed(const Duration(milliseconds: 100), () {
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
                                  isSelected[index] = !isSelected[index];
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '선택 삭제',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF05A2A),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFF05A2A),
                ),
              ),
              SizedBox(
                child: Row(children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('< 이전'),
                  ),
                  Container(
                    height: 35,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFCECECE),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('1')),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('다음 >'),
                  ),
                ]),
              ),
              filledButton(
                buttonName: '회차 추가',
                color: Color(0xFF3F99F7),
                onPressed: () {
                  context.go('/test/add');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
