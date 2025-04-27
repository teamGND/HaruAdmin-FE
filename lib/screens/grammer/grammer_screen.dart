import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/gaps.dart';
import 'package:haru_admin/widgets/level_dropdown.dart';
import 'package:haru_admin/widgets/pagination_controller.dart';
import 'package:haru_admin/widgets/status_chip.dart';

import '../../provider/intro_provider.dart';

class GrammerScreen extends ConsumerStatefulWidget {
  const GrammerScreen({super.key});

  @override
  ConsumerState<GrammerScreen> createState() => _GrammerDataState();
}

class _GrammerDataState extends ConsumerState<GrammerScreen> {
  late GrammarDataList grammarData;

  final int _pageSize = 10;
  final double TABLE_ROW_HEIGHT = 50;

  LEVEL dropdownValue = LEVEL.LEVEL1;
  int _currentPage = 0;

  final tableTitle = [
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
      ref.read(currentPageProvider.notifier).state = page;
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
      child: SingleChildScrollView(
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LevelDropdown(),
            ],
          ),
          Gaps.v10,
          FutureBuilder(
            future: _grammarListDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    grammarData.content.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                '데이터가 없습니다.\n<인트로> 페이지에서 회차와 한국어 단어를 먼저 추가해주세요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 80,
                              minHeight:
                                  MediaQuery.of(context).size.height - 215,
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Table(
                                border: const TableBorder(
                                  horizontalInside: BorderSide(
                                    color: Color(0xFFAFAFAF),
                                    width: 1,
                                  ),
                                ),
                                columnWidths: const {
                                  0: FlexColumnWidth(1), // 사이클
                                  1: FlexColumnWidth(1), // 세트
                                  2: FlexColumnWidth(1), // 회차
                                  3: FlexColumnWidth(3), // 타이틀
                                  4: FlexColumnWidth(7), // 제시문 제목
                                  5: FlexColumnWidth(1), //  예시 개수
                                  6: FlexColumnWidth(
                                      1), // 상태(status) - APPROVE, DELETE, WAIT
                                },
                                children: _buildTableRows(),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    PaginationController(
                        totalPages: grammarData.totalPages, goToPage: goToPage),
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
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF585858),
                    width: 1,
                  ),
                )),
            height: 50,
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
              // 1. 사이클
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].cycle.toString()),
              ),
            ),
            SizedBox(
              // 2. 세트
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].sets.toString()),
              ),
            ),
            SizedBox(
              // 3. 회차
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(grammarData.content[i].chapter.toString()),
              ),
            ),
            SizedBox(
              // 4. 타이틀
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(
                  grammarData.content[i].title ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              // 5. 제시문 제목
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
              // 6. 예시 개수
              height: TABLE_ROW_HEIGHT,
              child: Center(
                child: Text(
                    grammarData.content[i].exampleSentenceNumber.toString()),
              ),
            ),
            SizedBox(
              // 7. 상태(status) - APPROVE, DELETE, WAIT
              height: TABLE_ROW_HEIGHT,
              child: Center(
                  child: StatusChip(
                      status: DataStatus.fromString(
                          grammarData.content[i].status.toString()))),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
