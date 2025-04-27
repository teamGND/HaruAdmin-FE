import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/utils/convert_word_title.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/category_chip.dart';
import 'package:haru_admin/widgets/gaps.dart';
import 'package:haru_admin/widgets/level_dropdown.dart';
import 'package:haru_admin/widgets/pagination_controller.dart';
import 'package:haru_admin/widgets/status_chip.dart';

import '../../provider/intro_provider.dart';

class IntroTestScreen extends ConsumerStatefulWidget {
  const IntroTestScreen({super.key});

  @override
  _IntroTestScreenState createState() => _IntroTestScreenState();
}

class _IntroTestScreenState extends ConsumerState<IntroTestScreen> {
  late IntroDataList introData;
  // 페이지 번호
  static const int _pageSize = 10;
  static const double _rowHeight = 50;
  LEVEL dropdownValue = LEVEL.LEVEL1;

  late Future<void> _introDataFuture;

  @override
  void initState() {
    super.initState();
    _introDataFuture = fetchData(page: 0);
  }

  final tabletitle = [
    ' ',
    '유형',
    '사이클',
    '세트',
    '챕터',
    '타이틀',
    '상태',
  ];

  final List<bool> _selected = List.generate(_pageSize, (index) => false);

  Future<void> goToPage(int page) async {
    if (page < 0 || page >= introData.totalPages) {
      return;
    } else {
      await fetchData(page: page);
    }
  }

  void addChapter() {
    CATEGORY category;
    LEVEL level;
    int cycle;
    int sets;
    int chapter;
    String? title;
    List<String> wordList = [];

    ref.read(introProvider.notifier).clear();
    if (introData.content.isEmpty) {
      // 맨처음으로 새로 추가
      category = CATEGORY.WORD;
      level = levelFromString(dropdownValue.toString());
      cycle = 1;
      sets = 1;
      chapter = 1;
      title = '';
    } else {
      // 새로 추가
      category = categoryFromString(introData.content.last.category);
      level = levelFromString(introData.content.last.level);
      cycle = introData.content.last.cycle;
      sets = introData.content.last.sets;
      chapter = introData.content.last.chapter + 1;
      title = '';

      if (category == CATEGORY.MIDTERM) {
        category = CATEGORY.WORD;
        cycle += 1;
        sets = 1;
        chapter = 1;
      } else if (category == CATEGORY.TEST) {
        if (sets == 6) {
          category = CATEGORY.MIDTERM;
          sets = 7;
          chapter = 1;
        } else {
          category = CATEGORY.WORD;
          sets += 1;
          chapter = 1;
        }
      } else if (category == CATEGORY.GRAMMAR) {
        category = CATEGORY.TEST;
      } else if (category == CATEGORY.WORD) {
        if (chapter == 3) {
          category = CATEGORY.GRAMMAR;
        }
      }
    }
    ref.watch(introProvider.notifier).update(
          chapter: chapter,
          cycle: cycle,
          sets: sets,
          category: category,
          level: level,
          title: title,
          wordDatas: wordList,
        );

    context.go('/intro/add');
  }

  void updateWordGrammarChapter(IntroListComponentData data) {
    CATEGORY category = categoryFromString(data.category);
    LEVEL level = levelFromString(data.level);
    int cycle = data.cycle;
    int sets = data.sets;
    int chapter = data.chapter;
    int? introId = data.id;
    String? title = data.titleKor;
    List<String> wordList = [];
    if (category == CATEGORY.WORD && data.titleKor != null) {
      wordList = convertWordStringToList(title: data.titleKor!) ?? [];
      title = convertWordStringToTitle(title: data.titleKor!);
    } else {
      title = data.titleKor?.split('[')[0];
    }
    ref.watch(introProvider.notifier).update(
        dataId: introId,
        chapter: chapter,
        cycle: cycle,
        sets: sets,
        category: category,
        level: level,
        title: title,
        wordDatas: wordList);

    context.go('/intro/add');
  }

  void addTest(IntroListComponentData data) {
    String? title = data.titleKor;
    List<String> wordList = [];
    try {
      if (data.category == 'WORD' && data.titleKor != null) {
        wordList = convertWordStringToList(title: data.titleKor!) ?? [];
        title = convertWordStringToTitle(title: data.titleKor!);
      }
      ref.watch(introProvider.notifier).update(
          dataId: data.id,
          chapter: data.chapter,
          cycle: data.cycle,
          sets: data.sets,
          category: categoryFromString(data.category),
          level: dropdownValue,
          title: title,
          wordDatas: wordList);

      context.go('/test/add/${data.category}/${data.id}');
    } catch (e) {
      print(e);
    }
  }

  void deleteSelected() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '선택한 데이터를 삭제하시겠습니까?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: SizedBox(
              width: 400,
              height: 100,
              child: SingleChildScrollView(
                child: Text(
                  introData.content.fold(
                      "",
                      (previousValue, element) =>
                          previousValue +
                          (_selected[introData.content.indexOf(element)]
                              ? "챕터 ${element.chapter.toString()}. ${element.titleKor.toString()} \n"
                              : '')),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();
                    List<int> ids = introData.content
                        .asMap()
                        .entries
                        .where((element) => _selected[element.key])
                        .map((e) => e.value.id)
                        .toList();

                    print(ids);
                    await IntroDataRepository()
                        .deleteIntroData(ids)
                        .then((value) {
                      // 데이터 메시지 팝업
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text(value.toString())),
                        ),
                      );
                    });
                    setState(() {
                      _selected.fillRange(0, _pageSize, false);
                    });

                    int currentPage = ref.watch(currentPageProvider);

                    await fetchData(page: currentPage);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  Future<void> fetchData({required int page}) async {
    try {
      await IntroDataRepository()
          .getIntroDataList(
        page: page,
        size: _pageSize,
      )
          .then((value) {
        setState(() {
          introData = value;
        });
      });

      ref.read(currentPageProvider.notifier).state = page;
    } catch (e) {
      throw Exception(e);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LevelDropdown(),
                ],
              ),
              Gaps.v10,
              FutureBuilder(
                future: _introDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
                        introData.content.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    '데이터가 없습니다.',
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
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(10), // title
                                      6: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
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
                                                      color: Color(0xFF585858),
                                                    ))),
                                          ),
                                        ),
                                      ),
                                      ...List.generate(introData.content.length,
                                          (index) {
                                        IntroListComponentData data =
                                            introData.content[index];
                                        return TableRow(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          children: [
                                            SizedBox(
                                              height: _rowHeight,
                                              child: Center(
                                                child: Checkbox(
                                                  value: _selected[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selected[index] = value!;
                                                    });
                                                  },
                                                  fillColor: WidgetStateProperty
                                                      .resolveWith((states) {
                                                    if (states.contains(
                                                        WidgetState.selected)) {
                                                      return ColorPallete.red;
                                                    }
                                                    return Colors
                                                        .transparent; // Fill color when unchecked
                                                  }),
                                                  checkColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _rowHeight,
                                              child: Center(
                                                child: CategoryChip(
                                                    category:
                                                        Category.fromString(
                                                            data.category)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _rowHeight,
                                              child: Center(
                                                child:
                                                    Text(data.cycle.toString()),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _rowHeight,
                                              child: Center(
                                                child:
                                                    Text(data.sets.toString()),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _rowHeight,
                                              child: Center(
                                                child: Text(
                                                    data.chapter.toString()),
                                              ),
                                            ),
                                            SizedBox(
                                                height: _rowHeight,
                                                child: TextButton(
                                                    onPressed: () {
                                                      updateWordGrammarChapter(
                                                          data);
                                                    },
                                                    child: Text(
                                                      data.titleKor ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ))),
                                            SizedBox(
                                              height: _rowHeight,
                                              child: Center(
                                                  child: StatusChip(
                                                      status:
                                                          DataStatus.fromString(
                                                              data.status))),
                                            ),
                                            // SizedBox(
                                            //   height: _rowHeight,
                                            //   child: Center(
                                            //     child: (data.category == 'TEST' ||
                                            //             data.category ==
                                            //                 'MIDTERM')
                                            //         ? TextButton(
                                            //             onPressed: () {
                                            //               addTest(data);
                                            //             },
                                            //             child: const Text(
                                            //               '테스트',
                                            //               style: TextStyle(
                                            //                 color: Colors.orange,
                                            //               ),
                                            //             ))
                                            //         : (data.status == 'WAIT')
                                            //             ? const Text('-',
                                            //                 style: TextStyle(
                                            //                   color: Colors.grey,
                                            //                   fontSize: 12,
                                            //                 ))
                                            //             : TextButton(
                                            //                 onPressed: () {
                                            //                   addTest(data);
                                            //                 },
                                            //                 child: const Text(
                                            //                   '퀴즈',
                                            //                   style: TextStyle(
                                            //                     color:
                                            //                         Colors.blue,
                                            //                   ),
                                            //                 )),
                                            //   ),
                                            // ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                        Gaps.v10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClickableButton(
                                onPressed: deleteSelected,
                                color: ColorPallete.red,
                                text: '삭제'),
                            PaginationController(
                              totalPages: introData.totalPages,
                              goToPage: goToPage,
                            ),
                            (ref.watch(currentPageProvider) ==
                                    introData.totalPages - 1)
                                ? ClickableButton(
                                    text: '회차추가',
                                    onPressed: () => addChapter(),
                                    color: ColorPallete.blue)
                                : const SizedBox(width: 100),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
