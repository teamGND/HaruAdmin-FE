import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/utils/convert_word_title.dart';
import 'package:haru_admin/utils/enum_type.dart';

class IntroTestScreen extends ConsumerStatefulWidget {
  const IntroTestScreen({super.key});

  @override
  _IntroTestScreenState createState() => _IntroTestScreenState();
}

class _IntroTestScreenState extends ConsumerState<IntroTestScreen> {
  late IntroDataList introData;
  // 페이지 번호
  static const int _pageSize = 8;
  static const double _rowHeight = 50;
  /* TODO 현재페이지 쿠키에 저장 */
  int _currentPage = 0;
  LEVEL dropdownValue = LEVEL.LEVEL1;

  late Future<void> _introDataFuture;

  @override
  void initState() {
    super.initState();
    _introDataFuture = fetchData();
  }

  final tabletitle = [
    ' ',
    '유형',
    '사이클',
    '세트',
    '회차',
    '타이틀',
    '상태',
    '퀴즈/테스트',
  ];

  final List<bool> _selected = List.generate(_pageSize, (index) => false);

  void goToPage(int page) {
    if (page < 0 || page >= introData.totalPages) {
      return;
    } else {
      setState(() {
        _currentPage = page;
      });
    }
    fetchData();
  }

  void addChapter(IntroListComponentData? data) {
    String category;
    String level;
    int cycle;
    int sets;
    int chapter;
    int? introId;
    String? title;
    List<String> wordList = [];
    if (data == null) {
      // 새로 추가

      category = introData.content.last.category;
      level = introData.content.last.level;
      cycle = introData.content.last.cycle;
      sets = introData.content.last.sets;
      chapter = introData.content.last.chapter + 1;
      title = '';

      if (category == 'MIDTERM') {
        cycle += 1;
        sets += 1;
      } else if (category == 'TEST') {
        sets += 1;
      }
    } else {
      // 수정

      category = data.category;
      level = data.level;
      cycle = data.cycle;
      sets = data.sets;
      chapter = data.chapter;
      introId = data.id;

      if (data.category == 'WORD' && data.titleKor != null) {
        wordList = convertWordStringToList(title: data.titleKor!) ?? [];
        title = convertWordStringToTitle(title: data.titleKor!);
      }
    }
    ref.watch(introProvider.notifier).update(
        dataId: introId,
        chapter: chapter,
        cycle: cycle,
        sets: sets,
        category: CATEGORY.WORD,
        level: LEVEL.LEVEL1,
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
          category: CATEGORY.values.firstWhere(
              (element) => element.toString().split('.').last == data.category),
          level: dropdownValue,
          title: title,
          wordDatas: wordList);

      context.go('/test/add');
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
                  Navigator.of(context).pop();
                  List<int> ids = introData.content
                      .asMap()
                      .entries
                      .where((element) => _selected[element.key])
                      .map((e) => e.value.id)
                      .toList();
                  await IntroDataRepository().deleteIntroData(ids);
                  fetchData();
                },
                child: const Text('확인'),
              ),
            ],
          );
        });
  }

  Future<void> fetchData() async {
    try {
      await IntroDataRepository()
          .getIntroDataList(page: _currentPage, size: _pageSize)
          .then((value) {
        introData = value;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                '인트로 & 퀴즈/테스트 데이터',
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
                future: _introDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (introData.content.isEmpty) {
                    return const Center(child: Text('데이터가 없습니다.'));
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
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(10), // title
                            6: FlexColumnWidth(2),
                            7: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F0F0),
                              ),
                              children: List.generate(
                                tabletitle.length,
                                (index) => SizedBox(
                                    height: 40,
                                    child:
                                        Center(child: Text(tabletitle[index]))),
                              ),
                            ),
                            ...List.generate(introData.content.length, (index) {
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
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: Center(
                                      child: Text(data.category),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: Center(
                                      child: Text(data.cycle.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: Center(
                                      child: Text(data.sets.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: Center(
                                      child: Text(data.chapter.toString()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: (data.category == 'WORD' ||
                                            data.category == 'GRAMMAR')
                                        ? TextButton(
                                            onPressed: () {
                                              addChapter(data);
                                            },
                                            child: Text(
                                              data.titleKor ?? '',
                                            ))
                                        : Center(
                                            child: Text(data.titleKor ?? ''),
                                          ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: Center(
                                      child: Text(data.state ?? 'EMPTY'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _rowHeight,
                                    child: Center(
                                      child: TextButton(
                                          onPressed: () {
                                            addTest(data);
                                          },
                                          child: const Text(
                                            '퀴즈',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          )),
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
                            TextButton(
                              onPressed: () {
                                deleteSelected();
                              },
                              child: const Text(
                                '선택 삭제',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
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
                                  _currentPage != introData.totalPages
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
                                      goToPage(introData.totalPages - 1);
                                    },
                                    child: const Text('맨뒤로 >>'),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                addChapter(null);
                              },
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.blue)),
                              child: const Text('회차추가'),
                            )
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
