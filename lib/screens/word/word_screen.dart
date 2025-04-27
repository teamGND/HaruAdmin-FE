import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/gaps.dart';
import 'package:haru_admin/widgets/level_dropdown.dart';
import 'package:haru_admin/widgets/pagination_controller.dart';
import 'package:haru_admin/widgets/status_chip.dart';

class WordScreen extends ConsumerStatefulWidget {
  const WordScreen({super.key});

  @override
  ConsumerState<WordScreen> createState() => _WordState();
}

class _WordState extends ConsumerState<WordScreen> {
  late WordDataList wordData;

  final int _pageSize = 10;
  final double TABLE_ROW_HEIGHT = 50;
  // LEVEL dropdownValue = LEVEL.LEVEL1;

  final tabletitle = ['사이클', '세트', '회차', '타이틀', '학습 내용', '단어수', '상태'];

  late Future<void> _wordListDataFuture;

  void updateChapter({index}) {
    context.go('/word/add/${wordData.content[index].id}');
  }

  Future<void> fetchData({required int page}) async {
    try {
      await WordDataRepository()
          .getWordDataList(page: page, size: _pageSize)
          .then((value) {
        setState(() {
          wordData = value;
        });
      });

      // pagination number in provider into 0
      ref.read(currentPageProvider.notifier).state = page;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 0 || page >= wordData.totalPages) {
      return;
    } else {
      await fetchData(page: page);
    }
  }

  @override
  void initState() {
    super.initState();
    _wordListDataFuture = fetchData(page: 0);
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
                  future: _wordListDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        children: [
                          wordData.content.isEmpty
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
                                    minWidth:
                                        MediaQuery.of(context).size.width - 80,
                                    minHeight:
                                        MediaQuery.of(context).size.height -
                                            215,
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
                                        0: FlexColumnWidth(1),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(1),
                                        3: FlexColumnWidth(3), // 타이틀
                                        4: FlexColumnWidth(7), // 단어 리스트
                                        5: FlexColumnWidth(1),
                                        6: FlexColumnWidth(1),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Color(0xFF585858),
                                                  width: 1,
                                                ),
                                              )),
                                          children: List.generate(
                                            tabletitle.length,
                                            (index) => SizedBox(
                                              height: 40,
                                              child: Center(
                                                  child: Text(tabletitle[index],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF585858),
                                                      ))),
                                            ),
                                          ),
                                        ),
                                        ...List.generate(
                                            wordData.content.length, (index) {
                                          WordDataListComponent data =
                                              wordData.content[index];
                                          return TableRow(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            children: [
                                              SizedBox(
                                                // 사이클
                                                height: TABLE_ROW_HEIGHT,
                                                child: Center(
                                                  child: Text(
                                                      data.cycle.toString()),
                                                ),
                                              ),
                                              SizedBox(
                                                // 세트
                                                height: TABLE_ROW_HEIGHT,
                                                child: Center(
                                                  child: Text(
                                                      data.sets.toString()),
                                                ),
                                              ),
                                              SizedBox(
                                                // 회차
                                                height: TABLE_ROW_HEIGHT,
                                                child: Center(
                                                  child: Text(
                                                      data.chapter.toString()),
                                                ),
                                              ),
                                              SizedBox(
                                                // 타이틀
                                                height: TABLE_ROW_HEIGHT,
                                                child: Center(
                                                  child: Text(
                                                    data.title ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                // 단어 데이터
                                                height: TABLE_ROW_HEIGHT,
                                                child: TextButton(
                                                  onPressed: () {
                                                    updateChapter(index: index);
                                                  },
                                                  child: Center(
                                                    child: data.content != ''
                                                        ? Text(data.content!)
                                                        : const Text(
                                                            '데이터 입력하기',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                // 단어 개수
                                                height: TABLE_ROW_HEIGHT,
                                                child: Center(
                                                  child: Text(data.wordCount
                                                      .toString()),
                                                ),
                                              ),
                                              SizedBox(
                                                // 단어 상태
                                                height: TABLE_ROW_HEIGHT,
                                                child: Center(
                                                  child: StatusChip(
                                                      status:
                                                          DataStatus.fromString(
                                                              data.status)),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          PaginationController(
                            totalPages: wordData.totalPages,
                            goToPage: goToPage,
                          )
                        ],
                      );
                    }
                  }),
            ]),
          )),
    );
  }
}
