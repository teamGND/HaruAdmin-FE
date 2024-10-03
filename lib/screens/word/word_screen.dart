import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/utils/enum_type.dart';

import '../../provider/intro_provider.dart';

class WordScreen extends StatefulWidget {
  const WordScreen({super.key});

  @override
  State<WordScreen> createState() => _WordState();
}

class _WordState extends State<WordScreen> {
  final int _pageSize = 8;
  int _currentPage = 0;
  late WordDataList wordData;
  LEVEL dropdownValue = LEVEL.LEVEL1;
  double TABLE_ROW_HEIGHT = 50;

  final tabletitle = ['No.', '사이클', '세트', '회차', '타이틀', '학습 내용', '단어수', '상태'];

  late Future<void> _wordListDataFuture;

  @override
  void initState() {
    super.initState();
    _wordListDataFuture = fetchData();
  }

  void updateChapter({index}) {
    context.go('/word/add/${wordData.content[index].id}');
  }

  Future<void> fetchData() async {
    try {
      await WordDataRepository()
          .getWordDataList(page: _currentPage, size: _pageSize)
          .then((value) {
        wordData = value;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void goToPage(int page) {
    if (page < 0 || page >= wordData.totalPages) {
      return;
    } else {
      setState(() {
        _currentPage = page;
      });
    }
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Text(
                '단어 학습 데이터',
                style: Theme.of(context).textTheme.titleLarge,
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
                    enableSearch: false,
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
                              : Table(
                                  border: TableBorder.all(
                                    color: const Color(0xFFB9B9B9),
                                    width: 1,
                                  ),
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(3), // 타이틀
                                    5: FlexColumnWidth(7), // 단어 리스트
                                    6: FlexColumnWidth(1),
                                    7: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF0F0F0),
                                      ),
                                      children: List.generate(
                                        tabletitle.length,
                                        (index) => SizedBox(
                                            height: 50,
                                            child: Center(
                                                child:
                                                    Text(tabletitle[index]))),
                                      ),
                                    ),
                                    ...List.generate(wordData.content.length,
                                        (index) {
                                      WordDataListComponent data =
                                          wordData.content[index];
                                      return TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        children: [
                                          SizedBox(
                                            // No.
                                            height: TABLE_ROW_HEIGHT,
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            // 사이클
                                            height: TABLE_ROW_HEIGHT,
                                            child: Center(
                                              child:
                                                  Text(data.cycle.toString()),
                                            ),
                                          ),
                                          SizedBox(
                                            // 세트
                                            height: TABLE_ROW_HEIGHT,
                                            child: Center(
                                              child: Text(data.sets.toString()),
                                            ),
                                          ),
                                          SizedBox(
                                            // 회차
                                            height: TABLE_ROW_HEIGHT,
                                            child: Center(
                                              child:
                                                  Text(data.chapter.toString()),
                                            ),
                                          ),
                                          SizedBox(
                                            // 타이틀
                                            height: TABLE_ROW_HEIGHT,
                                            child: Center(
                                              child: Text(data.title ?? ''),
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
                                                          color: Colors.grey,
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
                                              child: Text(
                                                  data.wordCount.toString()),
                                            ),
                                          ),
                                          SizedBox(
                                            // 단어 상태
                                            height: TABLE_ROW_HEIGHT,
                                            child: Center(
                                              child: Text(
                                                  data.quizStatus.toString()),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      padding: const EdgeInsets.all(5),
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          )),
                                      child: Text(
                                        (_currentPage + 1).toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    _currentPage != wordData.totalPages
                                        ? GestureDetector(
                                            onTap: () {
                                              goToPage(_currentPage + 1);
                                            },
                                            child: const SizedBox(
                                                width: 50, child: Text('다음 >')),
                                          )
                                        : const SizedBox(width: 50),
                                    GestureDetector(
                                      onTap: () {
                                        goToPage(wordData.totalPages - 1);
                                      },
                                      child: const Text('맨뒤로 >>'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }),
            ]),
          )),
    );
  }
}
