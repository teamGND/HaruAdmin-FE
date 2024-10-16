import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/buttons.dart';

import '../../provider/intro_provider.dart';

class GrammerScreen extends ConsumerStatefulWidget {
  const GrammerScreen({super.key});

  @override
  ConsumerState<GrammerScreen> createState() => _GrammerDataState();
}

class _GrammerDataState extends ConsumerState<GrammerScreen> {
  late GrammarDataList grammarData;

  final int _pageSize = 10;
  final double TABLE_ROW_HEIGHT = 45;

  LEVEL dropdownValue = LEVEL.LEVEL1;
  int _currentPage = 0;

  final tableTitle = [
    'No.',
    '사이클',
    '세트',
    '회차',
    '타이틀',
    '제시문 제목',
    '예시 개수',
    '상태',
  ];

  final descriptionTitle = [
    '한국어',
    'ENG',
    'CHN',
    'VIE',
    'RUS',
  ];

  late Future<void> _grammarListDataFuture;

  Future<void> fetchData({required int page}) async {
    try {
      await GrammerDataRepository()
          .getGrammerDataList(page: page, size: _pageSize)
          .then((value) {
        setState(() {
          grammarData = value;
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 0 || page > grammarData.totalPages) {
      return;
    } else {
      setState(() {
        _currentPage = page;
      });

      await fetchData(page: page);
    }
  }

  void addChapter({
    int? index,
    int grammarId = 0,
  }) {
    if (index == null) {
      ref.watch(introProvider.notifier).update(
            level: dropdownValue,
            chapter: grammarData.content.last.chapter + 1,
          );
    } else {
      ref.watch(introProvider.notifier).update(
            dataId: grammarData.content[index].id,
            level: dropdownValue,
            cycle: grammarData.content[index].cycle,
            sets: grammarData.content[index].sets,
            chapter: grammarData.content[index].chapter,
            title: grammarData.content[index].title,
          );
    }

    context.go('/grammar/add/${grammarId.toString()}');
  }

  @override
  void initState() {
    super.initState();
    _grammarListDataFuture = fetchData(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const Text(
            '문법 학습 데이터',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '레벨',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              DropdownMenu<String>(
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Colors.white,
                  focusColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                width: 300,
                initialSelection: dropdownValue.toString(),
                onSelected: (value) {
                  setState(() {
                    dropdownValue = value as LEVEL;
                  });
                },
                dropdownMenuEntries: LEVEL.values.map((value) {
                  return DropdownMenuEntry<String>(
                    value: value.toString(),
                    label: value.toString().split('.')[1],
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: _grammarListDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Table(
                      border: TableBorder.all(
                        color: const Color(0xFFB9B9B9),
                        width: 1,
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1), // 사이클
                        2: FlexColumnWidth(1), // 세트
                        3: FlexColumnWidth(1), // 회차
                        4: FlexColumnWidth(3), // 타이틀
                        5: FlexColumnWidth(7), // 제시문 제목
                        6: FlexColumnWidth(1), //  예시 개수
                        7: FlexColumnWidth(
                            1), // 상태(status) - APPROVE, DELETE, WAIT
                      },
                      children: _buildTableRows(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _currentPage != 0
                            ? GestureDetector(
                                onTap: () {
                                  goToPage(_currentPage - 1);
                                },
                                child: const SizedBox(
                                    width: 50, child: Text('< 이전')))
                            : const SizedBox(width: 50),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              )),
                          child: Text(
                            (_currentPage + 1).toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        (_currentPage - 1 != grammarData.totalPages)
                            ? GestureDetector(
                                onTap: () {
                                  goToPage(_currentPage + 1);
                                },
                                child: const SizedBox(
                                    width: 50, child: Text('다음 >')),
                              )
                            : const SizedBox(width: 50),
                        (_currentPage - 1 != grammarData.totalPages)
                            ? GestureDetector(
                                onTap: () {
                                  goToPage(grammarData.totalPages - 1);
                                },
                                child: const Text('맨뒤로 >>'),
                              )
                            : const SizedBox(width: 50),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ]),
      ),
    ));
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [];

    rows.add(
      TableRow(
        children: List.generate(tableTitle.length, (index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
              color: Colors.grey[200],
            ),
            height: 30,
            child: Center(
              child: Text(
                tableTitle[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ),
    );

    if (grammarData.content == []) {
      return rows;
    }

    for (int i = 0; i < grammarData.content.length; i++) {
      rows.add(
        TableRow(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          children: [
            SizedBox(
              // 1. No.
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(
                  (i + 1).toString(),
                ),
              ),
            ),
            SizedBox(
              // 2. 사이클
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].cycle.toString()),
              ),
            ),
            SizedBox(
              // 3. 세트
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].sets.toString()),
              ),
            ),
            SizedBox(
              // 4. 회차
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].chapter.toString()),
              ),
            ),
            SizedBox(
              // 5. 타이틀
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].title ?? ''),
              ),
            ),
            SizedBox(
              // 6. 제시문 제목
              height: TABLE_ROW_HEIGHT,
              child: TextButton(
                onPressed: () {
                  addChapter(
                    index: i,
                    grammarId: grammarData.content[i].id,
                  );
                },
                child: Center(
                  child: grammarData.content[i].representSentences != ''
                      ? Text(grammarData.content[i].representSentences!
                          .split('<')
                          .last
                          .split('>')
                          .first)
                      : const Text(
                          '입력하기',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              // 단어 개수
              height: 35,
              child: Center(
                child: Text(
                    grammarData.content[i].exampleSentenceNumber.toString()),
              ),
            ),
            SizedBox(
              // 단어 개수
              height: 35,
              child: Center(
                child: Text(grammarData.content[i].status.toString()),
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
